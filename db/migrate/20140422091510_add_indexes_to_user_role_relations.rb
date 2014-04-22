class AddIndexesToUserRoleRelations < ActiveRecord::Migration
  def change
    add_index :user_role_relations, :user_id
    add_index :user_role_relations, :role_id
  end
end
