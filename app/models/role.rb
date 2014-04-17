class Role < ActiveRecord::Base
  has_many :user_role_relations
  has_many :users, :through => :user_role_relations

  scope :ordered, -> { order(:name) }
end
