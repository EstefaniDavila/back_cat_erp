SalesOrder.where(status: 'pending_dispatch').find_each do |so|
  next if so.dispatch_orders.exists?
  do_obj = DispatchOrder.create!(
    sales_order_id: so.id,
    status: 'pending',
    prepared_by_id: so.advisor&.user&.id || User.first&.id
  )
  so.quotation.quotation_items.where.not(product_id: nil).each do |qi|
    DispatchItem.create!(
      dispatch_order_id: do_obj.id,
      product_id: qi.product_id,
      quantity: qi.quantity || 1,
      checked: false
    )
  end
  puts "Created DispatchOrder for SalesOrder #{so.code}"
end
