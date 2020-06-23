class Public::MembersController < ApplicationController
  before_action :authenticate_public_member!
  before_action :correct_member

  def show
    @member = current_public_member
  end

  def edit
    @member = current_public_member
  end

  def leave
    @member = current_public_member
  end

  def update
    @member = current_public_member
    if @member.update(member_params)
      redirect_to public_member_path(current_public_member.id), notice: "ユーザー情報の編集に成功しました"
    else
      render 'edit'
    end
  end

  def update_status
    @member = current_public_member
    @member.update(member_params)
    reset_session
    redirect_to root_path, notice: "退会しました"
  end

  private
  def member_params
    params.require(:member).permit(:nick_name,:name,:kana_name,:email,:status,:member_image)
  end

  # url直打ちで他のユーザーに飛ばないようにするための記述
  def correct_member
    @member = current_public_member
    unless current_public_member == @member then
      redirect_to public_member_path(current_public_member.id)
    end
  end

end
