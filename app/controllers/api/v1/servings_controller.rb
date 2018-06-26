class Api::V1::ServingsController < Api::V1::BaseController
  before_action :check_user_is_operator

  def show
    if current_user.active_serving
     render_partial('api/v1/customers/customer', current_user.active_serving.customer)
    else
      render json: { id: nil }
    end
  end

  def next
    unless current_user.active_serving
      customer = Customer.in_queue.first
      return render_error(:not_valid, 'Queue is empty', :unprocessable_entity) unless customer
      customer.create_serving(operator: current_user)
      render_partial('api/v1/customers/customer', customer)
    else
      render_error(:not_valid, 'Active serving already present', :unprocessable_entity)
    end
  end

  def close
    if current_user.active_serving
      current_user.active_serving.closed!
      render_message('Serving closed successfully')
    else
      render_error(:not_valid, 'There is no active serving', :unprocessable_entity)
    end
  end

  def no_show
    if current_user.active_serving
      current_user.active_serving.no_show!
      render_message('Serving marked as no show successfully')
    else
      render_error(:not_valid, 'There is no active serving', :unprocessable_entity)
    end
  end
end