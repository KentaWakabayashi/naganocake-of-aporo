class Admins::OrdersController < ApplicationController
	before_action :authenticate_admin!
	
  def index
  	@orders = Order.page(params[:page]).per(10).order('created_at DESC')
  end

  def show
  	@order = Order.find(params[:id])
  	@order_items = @order.order_items
  	@total_price = @order_items.sum{|o| o.price * o.count}
  end

   def update_order
		@order = Order.find(params[:id])
		if order_params[:order_status] == '入金確認'
			@order.update(order_params)
			@order_items = @order.order_items
			@order_items.update_all(make_status: '製作待ち')
		else
			@order.update(order_params)
		end
			redirect_to admins_order_path
   end

	   private 
	   def order_params
	   	params.require(:order).permit(:order_status)
	   end
end
