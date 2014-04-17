class AddCounterCacheToGenre < ActiveRecord::Migration
  def change
    add_column :genres, :notes_count, :integer, default: 0, null: false
    add_column :genres, :evensongs_count, :integer, default: 0, null: false
  end
end
