class Manager::GenresController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :create, :edit, :update]
  def index
    @genres = Genre.all
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to manager_genres_path, notice: "カテゴリの登録に成功しました"
      else
      @genres = Genre.all
      render 'index'
      end
    end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
    redirect_to manager_genres_path, notice: "カテゴリの編集に成功しました"
    else
        render 'edit'
      end
  end

  private
  def genre_params
    params.require(:genre).permit(:name,:genre_image)
  end
end
