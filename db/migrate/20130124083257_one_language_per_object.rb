class OneLanguagePerObject < ActiveRecord::Migration
  def up
    add_column :notes, :language_id, :integer

    add_index :notes, :language_id

    Note.all.each do |n|
      n.language = n.languages.first
      n.save!
    end

    drop_table :note_language_assignments
  end

  def down
    create_table :note_language_assignments do |t|
      t.integer :note_id
      t.integer :language_id

      t.timestamps
    end

    add_index :note_language_assignments, :language_id
    add_index :note_language_assignments, :note_id

    Note.all.each do |n|
      n.languages = [n.language]
      n.save!
    end

    remove_column :note, :language_id
  end
end
