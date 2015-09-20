# Ordering products
class OrdersController < ApplicationController
  before_action :authenticate_user!

  def order
    product = Product.find params[:id]

    flash[:order_fail] = "Вам нельзя покупать котенек" if email_com?
    redirect_to product_path(product) and return if email_com?

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
