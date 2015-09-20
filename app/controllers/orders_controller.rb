# Ordering products
class OrdersController < ApplicationController
  before_action :authenticate_user!

  def order
    product = Product.find params[:id]
    PlaceOrderJob.perform_later current_user, product
    redirect_to product_path(product)
  end
end
