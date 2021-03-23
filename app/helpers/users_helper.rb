module UsersHelper
  def gravatar_for user, options = {size: Settings.user.gravatar.size}
    size = options[:size]
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravater_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravater_url, alt: user.name, class: "gravatar"
  end

  def follow_user
    current_user.active_relationships.build
  end

  def unfollow_user user
    current_user.active_relationships.find_by(followed_id: user.id)
  end
end
