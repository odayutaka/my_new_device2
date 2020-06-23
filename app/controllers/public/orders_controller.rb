class Public::OrdersController < ApplicationController
  before_action :set_addresses, only: [:new, :create, :edit, :update]

	def thanks
  end

  def index
    @orders = current_public_member.orders.page(params[:page]).reverse_order.per(5)
  end

  def new
  end

  def show
    @order = Order.find(params[:id])
    # 金額計算
      @postage = 500.to_i
      @total_price = 0
      @order.order_details.each do |order_detail|
        subtotal_price = order_detail.item.price * order_detail.quantity
        @total_price += subtotal_price
      end
      @payment = @total_price.to_i + @postage
  end

  def create
    @order = Order.new(order_params)
    @order.member_id = current_public_member.id
    @order.save!

    @new_postal_code = params[:postal_code]
    @new_address = params[:address]
    @new_address_name = params[:address_name]
    @new_phone_number = params[:phone_number]
    @address = Address.where(member_id: current_public_member,
                             postal_code: @new_postal_code,
                             address: @new_address,
                             address_name: @new_address_name,
                             phone_number: @new_phone_number)
    if @address.blank?
      @address = Address.new
      @address.postal_code = @new_postal_code
      @address.address = @new_address
      @address.address_name = @new_address_name
      @address.phone_number = @new_phone_number
      @address.member_id = current_public_member.id
      @address.save!
    end

    # オーダー詳細作成
      current_public_member.cart_items.each do |cart_item|
        @order_detail = OrderDetail.new(item_id: cart_item.item.id,
                                        order_id: @order.id , quantity: cart_item.quantity,
                                        price: cart_item.item.price)
        @order_detail.save!
      end

    current_public_member.cart_items.destroy_all
    redirect_to public_thanks_path
  end

  def confirm
    @order = Order.new
    @cart_items = current_public_member.cart_items
    @order.member_id = current_public_member.id

    if params[:address_option] == 0.to_s
      # addressDBのidを対象にしてkey=:address_collection、value=idを検索の材料にする
      @chosen_address = Address.find_by(id: params[:address_collection])
      @order.postal_code = @chosen_address.postal_code
      @order.address = @chosen_address.address
      @order.address_name = @chosen_address.address_name
      @order.phone_number = @chosen_address.phone_number
      # 入力ページからのパラメーターの値を習得
    else params[:address_option] == 1.to_s
      @order.postal_code = params[:new_postal_code]
      @order.address = params[:new_address]
      @order.address_name = params[:new_address_name]
      @order.phone_number = params[:new_phone_number]
    end

    @postage = 500.to_i
    @total_price = 0
    @cart_items.each do |cart_item|
      subtotal_price = cart_item.item.price * cart_item.quantity
      @total_price += subtotal_price
    end
    @payment = @total_price.to_i + @postage


  end


  private

    def set_addresses
      @addresses = Address.where(member_id: current_public_member.id)
    end

    def order_params
    params.require(:order).permit(:payment, :postal_code, :address, :address_name, :phone_number)
    end

    def address_params
    params.require(:address).permit(:postal_code, :address, :address_name, :phone_number, :member_id)
    end

end
