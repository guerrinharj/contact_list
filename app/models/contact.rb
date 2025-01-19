class Contact < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :tax_number, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :address_name, presence: true
  validates :address_number, presence: true
  validates :postal_code, presence: true
end
