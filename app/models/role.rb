class Role < ActiveRecord::Base
  scope :ordered, :order => 'name ASC'

  has_many :user_role_assignments
  has_many :users, :through => :user_role_assignments
end
