class Api::V1::CustomersController < Api::V1::BaseController
  before_action :check_user_is_admin

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      render_template(:show, :created)
    else
      render_errors(:not_valid, @customer, :unprocessable_entity)
    end
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def index
    records_count = Customer.count
    response.headers['Content-Range'] = "customers 0-#{records_count}/#{records_count}"
    @customers = Customer.all
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      render_template(:show)
    else
      render_errors(:not_valid, @customer, :unprocessable_entity)
    end
  end

  def destroy
    customer = Customer.find(params[:id])
    if customer.destroy
      render_message('Customer deleted successfully')
    else
      render_errors(:not_valid, customer, :unprocessable_entity)
    end
  end

  private

  def customer_params
    params.permit(
      :first_name,
      :last_name,
      :phone_number,
      attachments: []
    )
  end
end