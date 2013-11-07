# encoding: utf-8
require 'bcrypt'
class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
  #头像图片
  mount_uploader :avatar, AvatarUploader

  ##关系
  has_many :recommends,     :foreign_key => "user_id"

  ##常量
  ROLE={
    #普通用户
    :user=>1,
    #管理员
    :admin=>2,
    #超级管理员
    :system=>3
  }

  ##验证
  #case_sensitive大小写不敏感
  validates :email, :presence=>true, :uniqueness=>{:case_sensitive=>false} ,:length=>{:in=>3..100 }, :format=>{:with=>/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates :name, :uniqueness=>true, :length=>{:in=>2..100 }
  #confirmation自动验证字段xxx与字段xxx_confirmation字段内容相同
  validates :password, :presence=>true, :confirmation=>true, :length=>{:in=>4..40 }, :if => :password_required
  validates :password_confirmation, :presence=>true, :if => :password_required
  #整数
  validates :role, :numericality=>{:only_integer=>true}


  scope :no_system, -> {where("role!=3")}


  ##回调
  before_validation :default_values
  before_create :encrypt_password

  #验证email和密码
  def self.authenticate(email, password)
    user=where(:email=>email).first if email.present?
    user && user.has_password?(password) ? user : nil
  end
  def has_password?(password)
    ::BCrypt::Password.new(self.crypted_password) == password
  end

  #加密cookie信息
  def encrypt_cookie_value
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = Settings[:session_secret]
    Base64.encode64(cipher.update("#{id} #{crypted_password}") + cipher.final)
  end
  #校验cookie信息
  def self.validate_cookie(encrypted_value)
    user_id, crypted_password = decrypt_cookie_value(encrypted_value)
    if (user = User.find_by_id(user_id)) && (user.crypted_password = crypted_password)
      return user
    end
  end
  def self.decrypt_cookie_value(encrypted_value)
    decipher = OpenSSL::Cipher::AES.new(256, :CBC)
    decipher.decrypt
    decipher.key = Settings[:session_secret]
    plain = decipher.update(Base64.decode64(encrypted_value)) + decipher.final
    id, crypted_password = plain.split
    return id.to_i, crypted_password
  rescue
    return 0, ""
  end

  #角色名称
  def role_name
    if self.role == ROLE[:user]
      "普通用户"
    elsif self.role == ROLE[:admin]
      "管理员"
    else
      "其他"
    end
  end

  #是否管理员
  def admin?
    if self.role == ROLE[:user]
      false
    else
      true
    end
  end

  private
  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password) unless password.blank?
  end

  def default_values
    self.role ||= ROLE[:user]
  end

  def password_required
    self.crypted_password.blank? || self.password.present?
  end

end
