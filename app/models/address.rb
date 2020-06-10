class Address < ApplicationRecord

  validates :address, presence: true
  validates :address_name, presence: true
  validates :postal_code, presence: true
  validates :phone_number, presence: true
  
end
