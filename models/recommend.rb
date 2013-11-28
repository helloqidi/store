# encoding: utf-8
class Recommend < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :title, :type=>'string', :boost=>100
    indexes :desc_text, :type=>'string', :boost=>90
    indexes :tags, :type=>'string', :boost=>80
    indexes :status, :type=>'integer', :include_in_all => false
    indexes :sort, :type=>'integer', :include_in_all => false
    indexes :created_at, :as=>"created_at.to_i" ,:type=>'integer', :include_in_all => false
  end

  ##关系
  has_many :photos,     :foreign_key => "related_id",   dependent: :destroy
  belongs_to :user,     :foreign_key => "user_id"
  belongs_to :category, :foreign_key => "category_id"
  has_one :linklab,     :foreign_key => "recommend_id"

  ##常量
  STATUS={
    #草稿状态
    :draft=>1,
    #发布状态
    :published=>2
  }

  #备用类型字段
  SORT={
    #普通
    :normal => 0,
    #经验分享
    :exp => 1
  }

  ##验证
  validates :title, :presence=>true
  validates :description, :presence=>true
  validates :status, :presence=>true
  validates :sort, :presence=>true
  validates :category_id, :presence=>true
  validates :user_id, :presence=>true

  ##回调
  before_validation :default_values
  before_save :save_desc_text
  after_create :create_linklab

  ##过滤
  scope :draft, -> { where(status: STATUS[:draft]) }
  scope :published, -> { where(status: STATUS[:published]) }
  scope :recent, order('created_at DESC')
  scope :exp, -> { where(sort: SORT[:exp]) }

  #是否已经发布了
  def published?
    return true if self.status == STATUS[:published]
    false
  end

  #是否是经验了
  def exp?
    return true if self.sort == SORT[:exp]
    false
  end

  #跳转地址
  def go_url
    linklab = self.linklab
    if linklab.present?
      Store::App.url(:home, :go, :id => linklab.id)
    else
      self.store_url
    end
  end


  private
  def default_values
    self.status ||= STATUS[:draft]
    self.sort ||= SORT[:normal]
  end

  def save_desc_text
    self.desc_text = self.description.gsub(/<\/?[^>]*>/, "")
  end
  
  def create_linklab
    linklab = self.build_linklab(:click_cnt,0)
    linklab.save
  end

end
