class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :check_access, only: [:edit, :update, :destroy]


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
    # TODO: Проверка полученных данных
    @product = Product.new(product_params)
    
    redirect_to @product if @product.save
    render 'new'
  end

  def update
    @product = Product.find(params[:id])

    # TODO: добавить проверку данных
    redirect_to @product if @product.update_attributes(product_params)
    render 'edit'
  end

  def destroy
    Product.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to products_url
  end


  protected

  def check_access
    @product = Product.find(params[:id])
    redirect_to products_url unless current_user.id == @product.user_id
  end

  private

  def product_params
    params.require(:product).permit(:name, :description)
  end  
end
