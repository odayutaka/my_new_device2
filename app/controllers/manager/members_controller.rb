class Manager::MembersController < ApplicationController
  before_action :authenticate_manager_admin!

  def index
    @members = Member.page(params[:page]).per(10)
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to manager_members_path, notice: "ユーザー情報の更新に成功しました"
    else
      render 'edit'
    end
  end

  private
  def member_params
    params.require(:member).permit(:nick_name,:name,:kana_name,:email,:status,:member_image)
  end

end
