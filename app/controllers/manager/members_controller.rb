class Manager::MembersController < ApplicationController
  def index
    @items = Member.page(params[:page]).per(10)
  end
end
