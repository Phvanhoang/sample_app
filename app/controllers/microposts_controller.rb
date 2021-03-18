class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach micropost_params[:image]
    if @micropost.save
      flash[:success] = t("micropost.micropost_created!")
      redirect_to root_path
    else
      @feed_items = current_user.feed.by_created_at.paginate page: params[:page]
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t("micropost.micropost_deleted")
    else
      flash[:danger] = t("micropost.micropost_deleted_failed")
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    flash[:danger] = t("users.unallowable_user")
    redirect_to root_url unless @micropost
  end
end
