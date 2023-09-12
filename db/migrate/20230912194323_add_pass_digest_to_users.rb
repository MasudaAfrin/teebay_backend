class AddPassDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :password, :string
    add_column :users, :password_digest, :string
    add_column :users, :auth_token, :string
  end
end
