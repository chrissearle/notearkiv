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

      t.timestamps
    end

    create_table :note_language_assignments do |t|
      t.integer :note_id
      t.integer :language_id

      t.timestamps
    end

    add_index :notes, :composer_id
    add_index :notes, :genre_id
    add_index :notes, :period_id

    add_index :note_language_assignments, :language_id
    add_index :note_language_assignments, :note_id
  end
end
