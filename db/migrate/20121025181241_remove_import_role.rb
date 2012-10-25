class RemoveImportRole < ActiveRecord::Migration
  def up
    role = Role.find_by_name("import")
    role.user_role_assignments.map { |ura| ura.destroy }
    role.destroy
  end

  def down
    Role.new(:name => 'import')
  end
end
