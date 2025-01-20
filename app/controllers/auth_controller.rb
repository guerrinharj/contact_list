class AuthController < ApplicationController
    skip_before_action :authorize
    
    before_action :fetch_user, only: [:login, :delete_account]
    before_action :authenticate_user, only: [:login, :delete_account]

    def signup
        user = User.new(user_params)
        if user.save
            render json: { message: 'User created successfully', user: user }, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def login
        render json: { message: 'Login successful', user: @user }, status: :ok
    end

    def forgot_password
        user = User.find_by(email: params[:user][:email])
        if user
            UserMailer.forgot_password(user).deliver_now
            render json: { message: 'Password reset instructions sent to your email' }, status: :ok
        else
            render json: { message: 'Email not found' }, status: :not_found
        end
    end

    def delete_account
        password_confirmation = params[:user][:password_confirmation]
        unless password_confirmation == params[:user][:password]
            render json: { errors: ['Password confirmation does not match'] }, status: :unprocessable_entity
            return
        end

        @user.destroy
        render json: { message: 'Account deleted successfully' }, status: :ok
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def fetch_user
        @user = User.find_by(email: params[:user][:email])
        unless @user
            render json: { errors: ['Invalid email or password'] }, status: :unauthorized
        end
    end

    def authenticate_user
        unless @user&.authenticate(params[:user][:password])
            render json: { errors: ['Invalid email or password'] }, status: :unauthorized
        end
    end
end
