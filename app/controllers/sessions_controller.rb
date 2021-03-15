class SessionsController < ApplicationController
  before_action :load_user_email, only: [:create]

  def new; end

  def create
    if @user.authenticate params[:session][:password]
      log_in @user
      if params[:session][:remember_me] == "1"
        remember @user
      else
        forget @user
      end
      redirect_to @user
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def load_user_email
    @user = User.find_by email: params[:session][:email].downcase
    return if @user

    login_fail
  end

  def login_fail
    flash.now[:danger] = t("sessions.invalid_email_password_combination")
    render :new
  end
end
