class Public::CardsController < ApplicationController
  before_action :authenticate_public_member!
  before_action :set_card, only: [:new, :index, :destroy]
  before_action :set_payjpSecretKey, except: :new
  before_action :correct_member

  require "payjp"

  def new
    redirect_to action: :index, id: current_public_member.id if @card.present?
    @card = Card.new
    gon.payjpPublicKey = Rails.application.credentials[:payjp][:PAYJP_PUBLIC_KEY]
  end

  def create
    render action: :new if params['payjpToken'].blank?
    customer = Payjp::Customer.create(
      description: 'test',
      email: current_public_member.email,
      card: params['payjpToken'],
      metadata: {顧客ID: current_public_member.id}
    )
    @card = Card.new(
      card_id: customer.default_card,
      member_id: current_public_member.id,
      customer_id: customer.id
    )
    if @card.save
      flash[:notice] = 'クレジットカードの登録が完了しました'
      redirect_to action: :index, id: current_public_member.id
    else
      flash[:alert] = 'クレジットカード登録に失敗しました'
      redirect_to action: :new
    end
  end

   def index
    if @card.present?
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
  end

  def destroy
    customer = Payjp::Customer.retrieve(@card.customer_id)
    @card.destroy
    customer.delete
    flash[:notice] = 'クレジットカードが削除されました'
    redirect_to action: :index, id: current_public_member.id
  end

  private
  def set_card
    @card = Card.where(member_id: current_public_member.id).first
  end

  def set_payjpSecretKey
    Payjp.api_key = Rails.application.credentials[:payjp][:PAYJP_SECRET_KEY]
  end

  def correct_member
    @member = current_public_member
  end
end
