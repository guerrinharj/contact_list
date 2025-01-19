require 'net/http'
require 'uri'
require 'json'

class Contact < ApplicationRecord
  belongs_to :user

  before_validation :sanitize_postal_code

  validates :name, presence: true
  validates :tax_number, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :address_name, presence: true
  validates :address_number, presence: true
  validates :postal_code, presence: true
  validate :valid_postal_code

  private

  def sanitize_postal_code
    self.postal_code = postal_code.to_s.gsub(/\D/, '') if postal_code.present?
  end


  def valid_postal_code

    return if postal_code.blank?


    uri = URI.parse("https://viacep.com.br/ws/#{postal_code}/json/")
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      json_response = JSON.parse(response.body)


      unless json_response['cep']
        errors.add(:postal_code, 'is invalid according to ViaCEP')
      end
    else
      errors.add(:postal_code, 'could not be validated due to API failure')
    end
  rescue StandardError => e

    errors.add(:postal_code, "validation failed: #{e.message}")
  end
end
