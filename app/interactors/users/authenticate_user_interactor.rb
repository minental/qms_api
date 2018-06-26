class Users::AuthenticateUserInteractor
  include Interactor

  def call
    get_user
    authenticate_user
    create_session
  end

  private

  def get_user
    context.user = User.find_by(email: context[:email])
  end

  def authenticate_user
    unless context.user&.authenticate(context[:password])
      context.fail!(message: 'Wrong email/password combination')
    end
  end

  def create_session
    session = context.user.sessions.build
    if session.save
      context.session = session
    else
      context.fail!(message: session.errors.full_messages.join(', '))
    end
  end
end