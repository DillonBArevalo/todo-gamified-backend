class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    # In an application that cares at all about security the secret key would be an environment variable.
    # This app does not care about security at all.
    JWT.encode(payload, 'secretKey')
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, 'secretKey', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'Please log in or provide a correctly formatted token in your Authorization header (Authorization: \'Bearer <token>\')' }, status: :unauthorized unless logged_in?
  end
end
