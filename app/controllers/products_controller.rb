# Products controller. Show, add, edit, delete products by user.
class ProductsController < ApplicationController
  helper UsersHelper

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :check_access, only: [:edit, :update, :destroy]
  before_action :is_owner, only: [:new, :create]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(product_params)
    @product.user = current_user

    if @product.valid? && @product.save
      redirect_to @product
    else
      @error_messages = @product.errors.full_messages
      render 'new'
    end
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(product_params)
      redirect_to @product
    else
      @error_messages = @product.errors.full_messages
      render 'edit'
    end
  end

  def destroy
    Product.find(params[:id]).destroy
    redirect_to products_url
  end

  protected

  def check_access
    @product = Product.find(params[:id])
    redirect_to products_url unless current_user.id == @product.user_id
  end

  def is_owner
    unless current_user.role.name == 'owner'
      flash[:error] = 'Только владельцы котоферм могут добавлять котиков'
      redirect_to products_url
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :photo)
  end
end
