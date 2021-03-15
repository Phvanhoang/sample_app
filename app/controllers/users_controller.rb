class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("errors.user_not_found!")
    redirect_to new_user_path
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "welcome_to_the_sample_app!"
      log_in @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end
end
