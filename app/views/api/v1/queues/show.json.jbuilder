json.queue_size Customer.in_queue.count
json.customer_servings do
  Users::Operator.find_each do |operator|
    json.set! operator.id, operator.active_serving&.customer&.id
  end
end
json.customers Customer.in_queue.limit(5) do |customer|
  json.partial! 'api/v1/customers/customer', locals: { object: customer }
end