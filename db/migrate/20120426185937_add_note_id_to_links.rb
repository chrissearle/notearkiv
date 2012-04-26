class AddNoteIdToLinks < ActiveRecord::Migration
  def change
    add_column :links, :note_id, :integer

    add_index :links, :note_id
  end
end
