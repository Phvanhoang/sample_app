class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.by_created_at.paginate page: params[:page]
  end

  def help; end
end
