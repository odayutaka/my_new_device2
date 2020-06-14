class Genre < ApplicationRecord

  has_many :items, dependent: :destroy
  validates :name, presence: true, length: { maximum: 10 }

  attachment :genre_image

end
