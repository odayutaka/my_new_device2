class Item < ApplicationRecord

  has_many :cart_items, dependent: :destroy
  has_many :members, through: :cart_items
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details
  has_many :reviews, dependent: :destroy
  has_many :members, through: :reviews

  belongs_to :genre

  attachment :item_image

  validates :name, presence: true
  validates :price, presence: true
  validates :introduction, presence: true

end
