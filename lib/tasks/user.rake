namespace :user do
    desc "Create a new user"
    task create: :environment do
        puts "Enter the user's email:"
        email = STDIN.gets.chomp
    
        puts "Enter the user's password (minimum 6 characters):"
        password = STDIN.noecho(&:gets).chomp
        puts "\n"
    
        puts "Confirm the password:"
        password_confirmation = STDIN.noecho(&:gets).chomp
        puts "\n"
    
        if password != password_confirmation
            puts "Password confirmation does not match. Aborting."
            exit
        end
    
        user = User.new(email: email, password: password, password_confirmation: password_confirmation)
    
        if user.save
            puts "User created successfully!"
            puts "Email: #{user.email}"
        else
            puts "Failed to create user:"
            user.errors.full_messages.each do |error|
            puts "- #{error}"
            end
        end
    end
end