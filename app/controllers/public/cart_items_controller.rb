class Public::CartItemsController < ApplicationController
  before_action :authenticate_public_member!

  def create
    @cart_item = CartItem.new(cart_item_params)
    @cart_item.member_id = current_public_member.id
    @cart_item.save
    redirect_to public_cart_items_path
  end

  def index
    @cart_items = CartItem.all
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to public_cart_items_path, notice: "購入個数を変更しました"
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to public_cart_items_path, notice: "カート内商品を一件削除しました。"
  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:item_id,:member_id,:quantity)
  end

end
