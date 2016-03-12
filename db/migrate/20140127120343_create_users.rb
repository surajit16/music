class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :token, :default=>nil
      t.boolean :is_deleted, :default=>false
      t.boolean :verified, :default=>false
      t.boolean :is_admin, :default=>false
      t.string :password_digest

      t.timestamps
    end
  end
end
