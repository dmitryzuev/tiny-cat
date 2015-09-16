class PagesController < ApplicationController


  def welcome
    redirect_to products_path if user_signed_in?
  end

end
