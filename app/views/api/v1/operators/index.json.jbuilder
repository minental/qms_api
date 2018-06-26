json.array! @operators do |operator|
  json.partial! 'api/v1/operators/operator', locals: { object: operator }
end