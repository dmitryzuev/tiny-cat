# Static pages. Welcome page
class PagesController < ApplicationController
  def welcome
    redirect_to products_path if user_signed_in?

    @products = Product.where(pro: false).last(6)
  end
end
