class Vendors::OrdersController < Vendors::VendorsController
  def index
    @order_items = current_vendor.order_items
  end

  def update
    order_item = OrderItem.find(params[:id])
    order_item.update_attribute(:status, params[:status].to_i)
    order = order_item.order

    Order.find(order.id).update_attribute(:status, 1) if order.all_complete?

    redirect_to vendor_orders_path
  end

  def show
    @order = current_vendor.orders.find(params[:id])
    @order_items = current_vendor.order_items.where(order_id: @order.id)
  end
end
