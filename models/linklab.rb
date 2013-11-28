class Linklab < ActiveRecord::Base

  ##关系
  belongs_to :recommend, :foreign_key => "recommend_id"

  ##验证
  validates :recommend_id, :presence=>true

  ##过滤
  scope :bigger, order('click_cnt DESC')

end
