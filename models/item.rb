# encoding: utf-8
class Item < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  ##Tire搜索   https://github.com/karmi/retire
  #1,自动管理索引
  #使用 include Tire::Model::Callbacks后
  #(1)自动在create/destroy时建立/删除索引;
  #(2)在使用update_attribute,update_attributes时自动更新索引;update_column不更新;
  #
  #2,手动管理索引
  #注：官方建议在after_commit中使用手动管理索引,而不是after_save/after_destroy等
  #(1)删除
  #Tire.index('items'){delete}
  #(2)创建空索引文件
  #Tire.index('items'){create}
  #(3)创建索引记录(如果没有索引文件它会建立初始索引文件)
  #@item.index.store(@item)
  #(4)更新索引记录(如果没有索引文件它也会建立初始索引文件)
  #@item.update_index
  #(5)删除索引记录
  #@item.index.remove(@item)
  #(6)给多记录建立索引
  #Item.index.import(Item.all)
  #等同
  #Tire.index("items").import(Item.all)
  #
  #3,搜索方法
  #参考 https://github.com/karmi/retire/tree/master/test/integration
  #
  #
  #4,mapping指定索引字段(无论是自动/手动)
  #(1)indexes包含的参数如下：
  #[1]type,类型,包括:string,number(具体包括float,double,byte,short,integer,long),date,boolean,binary
  #参见 http://www.elasticsearch.org/guide/reference/mapping/core-types/
  #[2]boost,权重,默认1.0
  #参见 http://www.elasticsearch.org/guide/reference/mapping/core-types/
  #参见 http://www.elasticsearch.org/guide/reference/api/search/index-boost/
  #[3]as,重定义索引内容
  #[4]analyzer,分析,包括:standard,simple,whitespace,stop,custom,snowball,pattern,lang analyzer(具体又包括各种语言)
  #参见 http://www.elasticsearch.org/guide/reference/mapping/core-types/
  #参见 http://www.elasticsearch.org/guide/reference/index-modules/analysis/
  #[5]index,包括:analyzed(默认),not_analyzed,no
  #参见 http://www.elasticsearch.org/guide/reference/mapping/core-types/
  #[6]include_in_all,是否在搜索全部字段 all field 时出现,比如使用Item.search('key')时就不出现
  #参见 http://www.elasticsearch.org/guide/reference/mapping/core-types/
  #参见 http://www.elasticsearch.org/guide/reference/mapping/all-field/

  mapping do
    indexes :title, :type=>'string', :boost=>100
    indexes :description, :type=>'string'
    indexes :status, :type=>'integer', :include_in_all => false
    indexes :created_at, :as=>"created_at.to_i" ,:type=>'integer', :include_in_all => false
  end

  ##关系
  has_many :photos, :foreign_key=>"related_id"


  ##常量
  STATUS={
    #草稿状态
    :draft=>1,
    #发布状态
    :published=>2
  }


  ##验证
  validates :title, :presence=>true
  validates :description, :presence=>true
  validates :status, :presence=>true
  

  ##回调
  before_validation :default_values
  #检查描述中引用了哪些图片
  #after_save :check_photo_quote


  private
  def default_values
    self.status ||= STATUS[:draft]
  end

  def check_photo_quote
    return if self.description.blank?
    doc=Nokogiri::HTML(self.description)
    doc.css('img').each do |img|
      next unless img["src"].include?("photo")
      #src : /photo/small_90e2c82a83c3d7fd39fefb011367e846.jpg
      file_id=img["src"].split('_').second.split('.').first
      photo=Photo.where(:file=>file_id).first
      photo.update_column(:quote,Photo::QUOTE[:yes]) if photo.present?
    end
  end

end
