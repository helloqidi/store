# encoding: utf-8
require 'bcrypt'
class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  ##关系

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
  validates :password, :presence=>true, :confirmation=>true, :length=>{:in=>4..40 }
  validates :password_confirmation, :presence=>true
  #整数
  #validates :role, :numericality=>{:only_integer=>true}


  ##回调
  before_save :default_values
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


  private
  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password) unless password.blank?
  end

  def default_values
    self.role ||= ROLE[:user]
  end

end
