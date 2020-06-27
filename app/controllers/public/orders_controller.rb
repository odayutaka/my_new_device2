class Public::OrdersController < ApplicationController
  before_action :authenticate_public_member!
  before_action :set_card
  before_action :set_payjpSecretKey
  before_action :set_addresses, only: [:new, :create, :edit, :update]

	def thanks
  end

  def index
    @orders = current_public_member.orders.page(params[:page]).reverse_order.per(5)
  end

  def new
    if @current_public_member.card.blank?
      #登録された情報がない場合にカード登録画面に移動
      flash[:alert] = "購入前にご自身のクレジットカードを登録してください"
      redirect_to public_cards_path
    end
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

    # 新しい住所を入力した時addressDBに保存するための記述
    @new_postal_code = params[:postal_code]
    @new_address = params[:address]
    @new_address_name = params[:address_name]
    @new_phone_number = params[:phone_number]
    @address = Address.where(
      member_id: current_public_member,
      postal_code: @new_postal_code,
      address: @new_address,
      address_name: @new_address_name,
      phone_number: @new_phone_number
      )
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
        @order_detail = OrderDetail.new(
          item_id: cart_item.item.id,
          order_id: @order.id,
          quantity: cart_item.quantity,
          price: cart_item.item.price
          )
        @order_detail.save!
      end

    # pay.jpに売上げを登録
    @cart_items = current_public_member.cart_items
    @postage = 500.to_i
    @total_price = 0
    @cart_items.each do |cart_item|
      subtotal_price = cart_item.item.price * cart_item.quantity
      @total_price += subtotal_price
    end
    @payment = @total_price.to_i + @postage

    @purchaseByCard = Payjp::Charge.create(
      amount: @payment,
      customer: @card.customer_id,
      currency: 'jpy',
      card: params['payjpToken']
      )

    current_public_member.cart_items.destroy_all
    redirect_to public_thanks_path
  end

  def confirm
    @order = Order.new
    @cart_items = current_public_member.cart_items
    @order.member_id = current_public_member.id

    if params[:address_option] == 0.to_s
      # addressDBのidを対象にしてkey=:address_collectionからデータを取得
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
      if params[:new_postal_code].blank? or params[:new_address].blank? or params[:new_address_name].blank? or params[:new_phone_number].blank?
        flash[:notice] = "必要項目を入力してください"
        render 'new'
      end
    end
    # 支払い金額を計算
    @postage = 500.to_i
    @total_price = 0
    @cart_items.each do |cart_item|
      subtotal_price = cart_item.item.price * cart_item.quantity
      @total_price += subtotal_price
    end
    @payment = @total_price.to_i + @postage

    # カード情報を表示
    customer = Payjp::Customer.retrieve(@card.customer_id)
    default_card_information = customer.cards.retrieve(@card.card_id)
    @card_info = customer.cards.retrieve(@card.card_id)
    @exp_month = default_card_information.exp_month.to_s
    @exp_year = default_card_information.exp_year.to_s.slice(2,3)
    customer_card = customer.cards.retrieve(@card.card_id)
    @card_brand = customer_card.brand
    case @card_brand = customer_card.brand
    when "Visa"
      @card_src = "visa.png"
    when "JCB"
      @card_src = "jcb.png"
    when "MasterCard"
      @card_src = "master_card.png"
    when "American Express"
      @card_src = "american_express.png"
    when "Diners Club"
      @card_src = "diners_club.png"
    when "Discover"
      @card_src = "discover.png"
    end
  end

  private
    def set_card
      @card = Card.where(member_id: current_public_member.id).first
    end

    def set_addresses
      @addresses = Address.where(member_id: current_public_member.id)
    end

    def set_payjpSecretKey
      Payjp.api_key = Rails.application.credentials[:payjp][:PAYJP_SECRET_KEY]
    end

    def order_params
    params.require(:order).permit(:payment, :postal_code, :address, :address_name, :phone_number)
    end

    def address_params
    params.require(:address).permit(:postal_code, :address, :address_name, :phone_number, :member_id)
    end

end
