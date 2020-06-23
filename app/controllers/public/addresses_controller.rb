class Public::AddressesController < ApplicationController
  before_action :authenticate_public_member!
  before_action :correct_member, only: [:edit, :update]

  def new
    @address = Address.new
  end

  def index
    @addresses = current_public_member.addresses
  end

  def edit
    @address = Address.find(params[:id])
  end

  def create
    @address =Address.new(address_params)
    @address.member_id = current_public_member.id
    if @address.save
      redirect_to public_addresses_path, notice: "配送先の作成に成功しました"
    else
      render 'new'
    end
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      redirect_to public_addresses_path, notice: "配送先の更新に成功しました"
    else
      render 'edit'
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to public_addresses_path, notice: "配送先の削除に成功しました"
  end

  private
  def address_params
    params.require(:address).permit(:postal_code,:address,:address_name,:phone_number,:member_id)
  end

  # url直打ちで他のアドレスに飛ばないようにするための記述
  def correct_member
    @address = Address.find(params[:id])
    unless current_public_member.id == @address.member_id then
      redirect_to public_addresses_path
    end
  end
end
