class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :item
      t.string :title
      t.integer :originals
      t.integer :copies
      t.integer :instrumental
      t.string :voice
      t.integer :composer_id
      t.integer :genre_id
      t.integer :period_id
      t.string :instrument
      t.string :soloists
      t.text :comment
      t.integer :language_id

      t.timestamps
    end

    add_index :notes, :composer_id
    add_index :notes, :genre_id
    add_index :notes, :language_id
    add_index :notes, :period_id
  end
end
