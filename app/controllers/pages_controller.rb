class PagesController < ApplicationController


  def welcome
    redirect_to products_path if user_signed_in?

    @products = Product.last(6)
  end

end
