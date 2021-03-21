class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_relationship, only: :destroy

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow(@user)
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t("following.followed_user_not_found!")
      redirect_to root_path
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def load_relationship
    @relationship = Relationship.find_by id: params[:id]
    return if @relationship

    flash[:danger] = t("following.relationship_not_found!")
    redirect_back(fallback_location: root_path)
  end
end
