class AddEvensongIdToLinks < ActiveRecord::Migration
  def change
    add_column :links, :evensong_id, :integer
    
    add_index :links, :evensong_id
  end
end
