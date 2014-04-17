class CreateUserRoleAssignments < ActiveRecord::Migration
  def change
    create_table :user_role_assignments do |t|
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end

    add_index :user_role_assignments, :user_id
    add_index :user_role_assignments, :role_id
  end
end
