class PasswordResetsController < ApplicationController
  before_action :load_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t("password_reset.email_sent")
      redirect_to root_url
    else
      flash.now[:danger] = t("password_reset.email_not_found")
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, t("password_reset.cant_null"))
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t("password_reset.password_be_reset")
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t("users.user_not_found!")
    redirect_back(fallback_location: root_path)
  end

  def valid_user
    return if @user.authenticated?(:reset, params[:id])

    flash[:danger] = t("password_reset.invalid_link")
    redirect_back(fallback_location: root_path)
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t("password_reset.expired_link")
    redirect_to new_password_reset_url
  end
end
