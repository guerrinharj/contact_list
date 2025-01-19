user = User.first

if user.nil?
    puts "No users found in the database. Please create a user first."
    exit
end

contacts_data = [
    {
        name: "João Silva",
        tax_number: "123.456.789-01",
        phone: "11987654321",
        address_name: "Avenida Paulista",
        address_number: "1000",
        address_complement: "Apto 101",
        postal_code: "01310-100",
        latitude: -23.561732,
        longitude: -46.655981
    },
    {
        name: "Maria Oliveira",
        tax_number: "987.654.321-00",
        phone: "21998765432",
        address_name: "Rua XV de Novembro",
        address_number: "456",
        address_complement: "Bloco B",
        postal_code: "01010-010",
        latitude: -23.550405,
        longitude: -46.633949
    },
    {
        name: "Carlos Souza",
        tax_number: "321.654.987-12",
        phone: "31991234567",
        address_name: "Rua das Flores",
        address_number: "789",
        address_complement: nil,
        postal_code: "30110-020",
        latitude: -19.917299,
        longitude: -43.934559
    },
    {
        name: "Ana Pereira",
        tax_number: "456.789.123-45",
        phone: "41987654321",
        address_name: "Rua João Pessoa",
        address_number: "50",
        address_complement: "Casa",
        postal_code: "80010-000",
        latitude: -25.428356,
        longitude: -49.273252
    },
    {
        name: "Fernanda Lima",
        tax_number: "789.123.456-78",
        phone: "11999998888",
        address_name: "Avenida Ibirapuera",
        address_number: "1500",
        address_complement: "Escritório",
        postal_code: "04510-000",
        latitude: -23.601423,
        longitude: -46.672973
    }
]

contacts_data.each do |contact_data|
    user.contacts.create!(
        name: contact_data[:name],
        tax_number: contact_data[:tax_number],
        phone: contact_data[:phone],
        address_name: contact_data[:address_name],
        address_number: contact_data[:address_number],
        address_complement: contact_data[:address_complement],
        postal_code: contact_data[:postal_code],
        latitude: contact_data[:latitude],
        longitude: contact_data[:longitude]
    )
end

puts "Seeded #{contacts_data.size} contacts for user #{user.email}."
