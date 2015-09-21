# Ordering products
class OrdersController < ApplicationController
  before_action :authenticate_user!

  def order
    product = Product.find params[:id]

    if email_com?
      flash[:order_fail] = 'Вам нельзя покупать котенек'
      redirect_to product_path(product) && return
    end

    PlaceOrderJob.perform_later current_user, product
    flash[:order_placed] = "Запрос на покупку котеньки отправлен!
                            В случае успеха ждите письмо \xF0\x9F\x98\x8A"
    redirect_to product_path(product)
  end

  private

  def email_com?
    current_user.email.split('.').last == 'com'
  end
end
