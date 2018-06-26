class Api::V1::User::SessionsController < Api::V1::BaseController
  skip_before_action :check_current_user

  def create
    result = Users::AuthenticateUserInteractor.call(authentication_params)

    if result.success?
      @current_session = result.session
      @current_user = result.user

      set_access_token_to_header(@current_session)
      render_current_user(:created)
    else
      render_interactor_error(:not_valid, result, :unprocessable_entity)
    end
  end

  def destroy
    if current_session&.destroy
      render_message('Signed out successfully')
    else
      render_error(:not_found, 'Session not found', :not_found)
    end
  end

  private

  def authentication_params
    params.require(:user).permit(
      :email,
      :password
    )
  end
end