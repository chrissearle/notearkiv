class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :title
      t.string :path
      t.integer :note_id
      t.integer :evensong_id

      t.timestamps
    end

    add_index :uploads, :note_id
    add_index :uploads, :evensong_id
  end
end
