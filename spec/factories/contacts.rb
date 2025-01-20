FactoryBot.define do
    factory :contact do
        association :user
        name { Faker::Name.name }
        tax_number { CPF.generate }
        phone { Faker::PhoneNumber.phone_number }
        address_name { Faker::Address.street_name }
        address_number { Faker::Address.building_number }
        address_complement { Faker::Address.secondary_address }
        postal_code { '01310-100' }
    end
end