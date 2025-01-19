class ApplicationController < ActionController::API
    def encode_token(payload)
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode_token
        header = request.headers['Authorization']
        token = header.split(' ').last if header
        begin
            JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
        rescue
            nil
        end
    end

    def authorize
        decoded = decode_token
        if decoded
            @current_user = User.find_by(id: decoded[0]['user_id'])
        else
            render json: { errors: ['Unauthorized access'] }, status: :unauthorized
        end
    end
end