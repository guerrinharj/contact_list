class UsersController < ApplicationController
    before_action :authorize, only: [:profile]

    def profile
        render json: @current_user
    end
end