require 'net/http'
require 'uri'
require 'json'
require 'cpf_cnpj'

class Contact < ApplicationRecord
  belongs_to :user

  before_validation :sanitize_postal_code, :sanitize_tax_number
  before_save :fetch_coordinates_from_google

  validates :name, presence: true
  validates :tax_number, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :address_name, presence: true
  validates :address_number, presence: true
  validates :postal_code, presence: true
  validate :valid_postal_code
  validate :valid_tax_number


  private

  def sanitize_tax_number
    self.tax_number = tax_number.to_s.gsub(/\D/, '') if tax_number.present?
  end

  def sanitize_postal_code
    self.postal_code = postal_code.to_s.gsub(/\D/, '') if postal_code.present?
  end

  def valid_tax_number
    if tax_number.length == 11
      errors.add(:tax_number, 'is an invalid CPF') unless CPF.valid?(tax_number)
    elsif tax_number.length == 14
      errors.add(:tax_number, 'is an invalid CNPJ') unless CNPJ.valid?(tax_number)
    else
      errors.add(:tax_number, 'must be a valid CPF or CNPJ')
    end
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

  def fetch_coordinates_from_google
    return if postal_code.blank?

    api_key = ENV['GOOGLE_MAPS_API_KEY']
    address = URI.encode_www_form_component(postal_code)
    uri = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{api_key}")

    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      json_response = JSON.parse(response.body)

      if json_response['status'] == 'OK'
        location = json_response['results'].first['geometry']['location']
        self.latitude = location['lat']
        self.longitude = location['lng']
      elsif json_response['status'] != 'OK' && json_response['error_message']
        errors.add(:base, "Google Maps API error: #{json_response['error_message']}")
      else
        errors.add(:postal_code, 'could not fetch coordinates from Google Maps')
      end
    else
      errors.add(:base, 'Failed to connect to Google Maps API')
    end
  rescue StandardError => e
    errors.add(:base, "Error fetching coordinates: #{e.message}")
  end
end
