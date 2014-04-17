class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title
      t.string :url
      t.integer :evensong_id
      t.integer :note_id

      t.timestamps
    end

    add_index :links, :evensong_id
    add_index :links, :note_id
  end
end
