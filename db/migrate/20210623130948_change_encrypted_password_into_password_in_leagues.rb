class ChangeEncryptedPasswordIntoPasswordInLeagues < ActiveRecord::Migration[6.0]
  def change
    rename_column :leagues, :encrypted_password, :password
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
