class Review < ApplicationRecord

  belongs_to :item
  belongs_to :member

  validates :title, presence: true, length: { maximum: 20 }
  validates :comment, presence: true, length: { maximum: 100 }
  validates :rating, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true

  validates_uniqueness_of :item_id, scope: :member_id
end
