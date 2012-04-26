class CreateEvensongs < ActiveRecord::Migration
  def change
    create_table :evensongs do |t|
      t.string :title
      t.integer :psalm
      t.integer :composer_id
      t.integer :genre_id
      t.string :soloists
      t.text :comment

      t.timestamps
    end

    add_index :evensongs, :composer_id
    add_index :evensongs, :genre_id

  end
end
