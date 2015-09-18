class AddStoreIdToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :store
  end
end
