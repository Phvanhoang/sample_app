class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :find_user, except: [:new, :index, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "welcome_to_the_sample_app!"
      log_in @user
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t("users.profile_updated_mess")
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("users.user_deleted_mess")
    else
      flash[:danger] = t("users.user_deleted_failed")
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("users.please_log_in")
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_url) unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("users.user_not_found!")
    redirect_back(fallback_location: root_path)
  end
end
