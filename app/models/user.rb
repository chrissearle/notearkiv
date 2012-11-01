# coding: UTF-8

require 'digest/sha1'

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.logged_in_timeout(30.minutes)
  end

  has_many :user_role_assignments
  has_many :roles, :through => :user_role_assignments

  scope :preloaded, :include => [:roles]

  validates_presence_of :roles

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def one_time_code
    self.onetime = Digest::SHA1.hexdigest("onetime #{Time.now} #{current_login_ip}")

    self.save

    self.onetime
  end

  def send_reset_password
    code = one_time_code

    ResetPassword.reset_password(self, code).deliver
  end

  def clear_one_time_code
    self.onetime = nil

    self.save
  end

  def display_name
    name.blank? ? username : name
  end

  def update_from_user_params(user)
    self.email = user["email"]
    self.password = user["password"]
    self.password_confirmation = user["password_confirmation"]
  end
end
