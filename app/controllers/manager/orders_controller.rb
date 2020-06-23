class Manager::OrdersController < ApplicationController
  before_action :authenticate_manager_admin!

  def today
    @orders = Order.where(created_at: Time.zone.now.all_day).page(params[:page]).reverse_order.per(10)
  end

  def member
    @member = Member.find(params[:id])
    @orders = @member.orders.page(params[:page]).reverse_order.per(10)
  end

  def index
    @orders = Order.page(params[:page]).reverse_order.per(10)
  end

  def edit
    @order = Order.find(params[:id])
    @postage = 500.to_i
    @total_price = 0
      @order.order_details.each do |order_detail|
        subtotal_price = order_detail.item.price * order_detail.quantity
        @total_price += subtotal_price
      end
      @payment = @total_price.to_i + @postage
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    redirect_to manager_orders_path, notice: "配送状況の更新に成功しました"
  end

  private
  def order_params
    params.require(:order).permit(:delivery)
  end


end
