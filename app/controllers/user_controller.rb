class UserController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "User saved."
    else
      render :new
    end
  end

  def show
    @user = User.find(params['id'])
  end

  def index
    @users = User.all
  end


  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
