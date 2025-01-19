class ApplicationController < ActionController::API
    before_action :authorize

    private

    def authorize
        email = request.headers['Email']
        password = request.headers['Password']
    
        if email.present? && password.present?
            @current_user = User.find_by(email: email)

            if @current_user&.authenticate(password)
                return true
            else
                render json: { errors: ['Invalid email or password'] }, status: :unauthorized
            end
        else
            render json: { errors: ['Missing email or password headers'] }, status: :unauthorized
        end
    end
end