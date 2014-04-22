class User < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable, :trackable, :timeoutable

  has_many :user_role_relations
  has_many :roles, :through => :user_role_relations

  scope :ordered, -> { order(:name) }
  scope :preloaded, -> { includes :roles }

  validates_presence_of :roles

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def display_name
    name.blank? ? username : name
  end
end
