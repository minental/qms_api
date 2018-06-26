json.array! @customers do |customer|
  json.partial! 'api/v1/customers/customer', locals: { object: customer }
end