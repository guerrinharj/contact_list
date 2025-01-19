class UserMailer < ApplicationMailer
    default from: ENV['GMAIL_USER']

    def forgot_password(user)
        @user = user
        base_url = ENV['APP_URL']
        @reset_link = "#{base_url}/reset_password?token=#{SecureRandom.hex(10)}"
        mail(to: @user.email, subject: 'Password Reset Instructions')
    end
end
