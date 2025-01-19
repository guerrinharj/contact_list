class AuthController < ApplicationController
    def signup
        user = User.new(user_params)
        if user.save
            render json: { message: 'User created successfully', user: user }, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
            token = encode_token(user_id: user.id)
            render json: { token: token, message: 'Login successful' }, status: :ok
        else
            render json: { errors: ['Invalid email or password'] }, status: :unauthorized
        end
    end

    def forgot_password
        user = User.find_by(email: params[:email])
        if user
            render json: { message: 'Password reset instructions sent to your email' }, status: :ok
        else
            render json: { errors: ['Email not found'] }, status: :not_found
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
