class AddStoreIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :store, :reference
  end
end
