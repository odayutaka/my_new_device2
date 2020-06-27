class Public::HomesController < ApplicationController
  def top
  	# おすすめ商品をレビューが多い順に４つ表示させる
  	@item_reviews = Item.find(Review.group(:item_id).order("count(item_id) desc").limit(4).pluck(:item_id))
  	@genres = Genre.all
  end

  def about
  end

end
