class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title, :null => false
      t.text :content, :null => false
      t.datetime :startdt
      t.datetime :enddt
      t.boolean :active_flag, :null => false, :default => false
      t.string :msgtype, :null => false

      t.timestamps
    end
  end
end
