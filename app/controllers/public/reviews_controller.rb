class Public::ReviewsController < ApplicationController
  before_action :authenticate_public_member!
  before_action :correct_member, only: [:destroy]

  def create
    # 二次元配列
    @item = Item.find(params[:review][:item_id])
    @review = Review.new(review_params)
    @review.member_id = current_public_member.id
    if @review.save
      flash[:notice] = "レビューの投稿に成功しました"
      redirect_back(fallback_location: root_path)
    else
      flash[:notice] = "レビューの投稿に失敗しました"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @review.destroy
    flash[:notice] = "レビューを１件削除しました"
    redirect_back(fallback_location: root_path)
  end


  private
  def review_params
    params.require(:review).permit(:item_id, :title, :comment, :rating)
  end

  def correct_member
   @review = current_public_member.reviews.find_by(id: params[:id])
    unless @review
      redirect_to public_items_path
    end
  end

end
