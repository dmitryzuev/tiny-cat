class AddDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :photo
    add_column :users, :passport, :photo
    add_column :users, :birthdate, :date
  end
end
