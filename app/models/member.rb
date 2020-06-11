class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cart_items, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :items, through: :cart_items

  attachment :member_image

  validates :name, presence: true
  validates :kana_name, presence: true

  # 会員ステータスがtrueでないとログインできない
  def active_for_authentication?
    super && (self.status == true)
  end

  # 会員一覧をIDの古い順番で表示
  default_scope -> {order(created_at: :desc)}
end
