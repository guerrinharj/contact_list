require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:user) { create(:user) }
  let(:contact) { build(:contact, user: user) } 

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(contact).to be_valid
    end

    it 'is invalid without a user' do
      contact.user = nil
      expect(contact).to_not be_valid
      expect(contact.errors[:user]).to include('must exist')
    end

    it 'is invalid without a name' do
      contact.name = nil
      expect(contact).to_not be_valid
      expect(contact.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a duplicate tax number' do
      create(:contact, tax_number: contact.tax_number, user: user)
      expect(contact).to_not be_valid
      expect(contact.errors[:tax_number]).to include('has already been taken')
    end

    it 'is invalid with an incorrect tax number format' do
      contact.tax_number = 'invalid'
      expect(contact).to_not be_valid
      expect(contact.errors[:tax_number]).to include('must be a valid CPF or CNPJ')
    end

    it 'is invalid without a postal code' do
      contact.postal_code = nil
      expect(contact).to_not be_valid
      expect(contact.errors[:postal_code]).to include("can't be blank")
    end
  end

  context 'callbacks' do
    it 'sanitizes tax number before validation' do
      contact.tax_number = '123.456.789-09'
      contact.valid?
      expect(contact.tax_number).to eq('12345678909')
    end

    it 'sanitizes postal code before validation' do
      contact.postal_code = '01310-100'
      contact.valid?
      expect(contact.postal_code).to eq('01310100')
    end
  end

  context 'Google Maps API integration' do
    it 'fetches latitude and longitude for a valid postal code' do
      contact.send(:fetch_coordinates_from_google)

      contact.save!

      expect(contact.latitude.to_i).to eq(0)
      expect(contact.longitude.to_i).to eq(0)
    end

    it 'does not save contact if Google Maps API fails' do
      contact.postal_code = '00000-000'

      contact.send(:fetch_coordinates_from_google)

      expect(contact).to_not be_valid
    end
  end
end
