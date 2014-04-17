class AddCounterCacheToLanguage < ActiveRecord::Migration
  def change
    add_column :languages, :notes_count, :integer, default: 0, null: false
  end
end
