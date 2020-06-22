class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cart_items, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :items, through: :cart_items
  has_one :card, dependent: :destroy

  attachment :member_image

  validates :nick_name, presence: true
  validates :name, presence: true
  validates :kana_name, presence: true

  # 会員ステータスがtrueでないとログインできない
  def active_for_authentication?
    super && (self.status == true)
  end

end
