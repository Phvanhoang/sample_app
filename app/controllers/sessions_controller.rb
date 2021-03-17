class SessionsController < ApplicationController
  before_action :load_user_email, only: :create

  def new; end

  def create
    if @user.authenticate params[:session][:password]
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        flash[:warning] = t("account_activations.account_not_activated")
        redirect_to root_path
      end
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
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
