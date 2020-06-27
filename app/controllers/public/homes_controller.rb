class Public::HomesController < ApplicationController
  def top
  	# おすすめ商品を４つランダムに表示させる
  	@items = Item.limit(4).shuffle
  	@genres = Genre.all
  end

  def about
  end

end
