class Manager::ItemsController < ApplicationController
  def index
    @items = Item.all.page(params[:page]).per(10)
  end

  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to manager_items_path, notice: "商品情報の作成に成功しました"
    else
      render 'new'
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to manager_items_path, notice: "商品情報の編集に成功しました"
    else
      render 'edit'
    end
  end

  private
  def item_params
    params.require(:item).permit(:genre_id,:name,:price,:introduction,:item_image,:status)
  end
end
