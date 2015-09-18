class AddDataToUser < ActiveRecord::Migration
  def change
    add_attachment :users, :avatar
    add_attachment :users, :passport
    add_column :users, :birthdate, :date
  end
end
