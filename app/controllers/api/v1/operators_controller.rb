class Api::V1::OperatorsController < Api::V1::BaseController
  before_action :check_user_is_admin

  def create
    @operator = Users::Operator.new(operator_params)
    if @operator.save
      render_template(:show, :created)
    else
      render_errors(:not_valid, @operator, :unprocessable_entity)
    end
  end

  def show
    @operator = Users::Operator.find(params[:id])
  end

  def index
    records_count = Users::Operator.count
    response.headers['Content-Range'] = "operators 0-#{records_count}/#{records_count}"
    @operators = Users::Operator.all
  end

  def update
    @operator = Users::Operator.find(params[:id])
    if @operator.update(operator_params)
      render_template(:show)
    else
      render_errors(:not_valid, @operator, :unprocessable_entity)
    end
  end

  def destroy
    operator = Users::Operator.find(params[:id])
    if operator.destroy
      render_message('Operator deleted successfully')
    else
      render_errors(:not_valid, operator, :unprocessable_entity)
    end
  end

  private

  def operator_params
    params.permit(
      :first_name,
      :last_name,
      :email,
      :password
    )
  end
end