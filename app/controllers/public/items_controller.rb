class Public::ItemsController < ApplicationController
  def index
    @items = Item.all.page(params[:page]).reverse_order.per(8)
    @genres = Genre.all
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
    @genres = Genre.all
    @review = Review.new
    @reviews = @item.reviews
  end

end
