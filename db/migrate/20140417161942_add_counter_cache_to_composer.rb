class AddCounterCacheToComposer < ActiveRecord::Migration
  def change
    add_column :composers, :notes_count, :integer, default: 0, null: false
    add_column :composers, :evensongs_count, :integer, default: 0, null: false
  end
end
