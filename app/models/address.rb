class Address < ApplicationRecord

  validates :address, presence: true
  validates :address_name, presence: true
  validates :postal_code, presence: true
  validates :phone_number, presence: true


  	# セレクトボックスのアドレス情報を全て表示
  def address_info
 	self.postal_code + "　" + self.address + "　" + self.address_name + "　" + self.phone_number
  end

end
