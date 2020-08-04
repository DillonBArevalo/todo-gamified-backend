class UsersController < ApplicationController
  skip_before_action :authorized

  def create
    @user = User.new(user_params)
    if @user.save
      token = encode_token({user_id: @user.id})
      render json: {user: @user.data, token: token}
    else
      render json: {errors: @user.errors.full_messages}
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
