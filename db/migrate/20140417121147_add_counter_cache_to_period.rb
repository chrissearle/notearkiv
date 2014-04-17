class AddCounterCacheToPeriod < ActiveRecord::Migration
  def change
    add_column :periods, :notes_count, :integer, default: 0, null: false
  end
end
