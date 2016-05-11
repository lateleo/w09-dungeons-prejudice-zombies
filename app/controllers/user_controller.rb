class UserController < ApplicationController
  skip_before_action :require_login, only: [:index, :new, :create]

  def new
    redirect_back_or_to(show_user_path(current_user.id)) if current_user
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to(:users, notice: "User saved.")
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
