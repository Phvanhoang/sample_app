class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :by_created_at, ->{order created_at: :desc}
  validates :user_id, presence: true
  validates :content, presence: true,
            length: {maximum: Settings.micropost.content.max_length}
  validates :image,
            content_type: {
              in: %w(image/jpeg image/gif image/png),
              message: I18n.t("micropost.must_valid_image_format")
            },
            size: {
              less_than: Settings.micropost.image.size_lt.megabytes,
              message: I18n.t("micropost.must_less_than", size:
                       Settings.micropost.image.size_lt)
            }
  def display_image
    image.variant(resize_to_limit: [Settings.micropost.image.hsize_limit,
                                    Settings.micropost.image.wsize_limit])
  end
end
