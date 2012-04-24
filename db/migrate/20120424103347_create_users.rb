class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :persistence_token
      t.string :crypted_password
      t.string :password_salt
      t.integer :login_count
      t.integer :failed_login_count
      t.datetime :last_request_at, :datetime
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      t.string :onetime
      t.string :name

      t.timestamps
    end
  end
end
