class Api::V1::BaseController < ApplicationController
  before_action :verify_requested_format!
  before_action :check_current_user

  respond_to :json

  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
  rescue_from ActiveRecord::RecordNotFound,       with: :render_not_found
  rescue_from ActionController::UnknownFormat,    with: :render_unsupported_format

  private

  def check_current_user
    render_error(:unauthorized, 'not authorized', :unauthorized) unless current_user
  end

  def check_user_is_admin
    render_error(:forbidden, 'forbidden', :forbidden) unless current_user.role == 'admin'
  end

  def check_user_is_operator
    render_error(:forbidden, 'forbidden', :forbidden) unless current_user.role == 'operator'
  end

  def current_user
    @current_user ||= current_session.try(:user)
  end

  def current_session
    @current_session ||= get_session
  end

  def signed_in?
    false unless current_user
  end

  def get_session
    session = Session.not_expired.find_by(access_token: request.headers['Access-Token'])
    set_access_token_to_header(session) if session.try(:touch)
    session
  end

  def set_access_token_to_header(session)
    response.headers['Access-Token'] = session.access_token
  end

  def render_template(template = nil, status = nil)
    render template, status: status
  end

  def render_partial(partial, object, status = nil)
    render partial: partial, locals: { object: object }, status: status
  end

  def render_current_user(status = nil)
    render 'api/v1/users/show', status: status
  end

  def render_message(message, status = nil)
    json = { message: message }
    render json: json, status: status
  end

  def render_error(type, message, status)
    json = { type: type, message: message }
    render json: json, status: status
  end

  def render_errors(type, object, status)
    render_error(type, object.errors.full_messages.join(', '), status)
  end

  def render_interactor_error(type, interactor, status)
    render_error(type, interactor.message, status)
  end

  def render_parameter_missing(e)
    render_error(:parameter_missing, e.message, :unprocessable_entity)
  end

  def render_not_found(e)
    error_message = e.message.sub(/ \[.*/, '').humanize
    render_error(:not_found, error_message, :not_found)
  end

  def render_unsupported_format
    render_error(:unsupported_format, 'Requested response format is not supported', :not_acceptable)
  end
end