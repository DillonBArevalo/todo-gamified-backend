class SessionsController < ApplicationController
  skip_before_action :authorized

  def new
    @user = User.new
    render layout: 'sessions'
  end

  def create
    @user = User.find_by(username: login_params[:username])
    if @user && @user.try(:authenticate, login_params[:password])
      token = encode_token({user_id: @user.id})
      render json: {user: @user.data, token: token}
    else
      render json: {error: "Invalid username or password"}, status: :unauthorized
    end
  end

  private

  def login_params
    params.require(:user).permit(:username, :password)
  end
end
