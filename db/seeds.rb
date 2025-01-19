user = User.first

if user.nil?
    puts "No users found in the database. Please create a user first."
    exit
end

contacts_data = [
    {
        name: "Gabriel Guerra",
        tax_number: "142.688.237-86",
        phone: "21971281044",
        address_name: "Rua Leopoldo Miguez",
        address_number: "161",
        address_complement: "Apto 601",
        postal_code: "22060-021"
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
        postal_code: contact_data[:postal_code]
    )
end

puts "Seeded #{contacts_data.size} contacts for user #{user.email}."
