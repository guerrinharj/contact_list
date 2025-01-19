require 'net/http'
require 'uri'
require 'json'
require 'cpf_cnpj'

class ContactsController < ApplicationController
    before_action :authorize
    before_action :set_contact, only: [:show, :update, :destroy]

    def index
        contacts = @current_user.contacts

        contacts = contacts.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%") if params[:name].present?
        contacts = contacts.where('tax_number = ?', params[:tax_number].gsub(/\D/, '')) if params[:tax_number].present?

        contacts = contacts.order(:name)

        render json: contacts
    end

    def show
        render json: @contact
    end

    def create
        contact = Contact.new(contact_params)
        contact.user = @current_user

        if contact.save
            render json: contact, status: :created
        else
            render json: { errors: contact.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @contact.update(contact_params)
            render json: @contact
        else
            render json: { errors: @contact.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @contact.destroy
        render json: { message: 'Contact deleted successfully' }, status: :ok
    end

    def find_address
        postal_code = params[:postal_code].to_s.gsub(/\D/, '')
        return render json: { errors: ['Postal code is required'] }, status: :bad_request if postal_code.blank?
    
        uri = URI.parse("https://viacep.com.br/ws/#{postal_code}/json/")
        response = Net::HTTP.get_response(uri)
    
        if response.is_a?(Net::HTTPSuccess)
            address_data = JSON.parse(response.body)
            if address_data['cep']
                render json: address_data, status: :ok
            else
                render json: { errors: ['Invalid postal code'] }, status: :unprocessable_entity
            end
            else
            render json: { errors: ['Failed to fetch address from ViaCEP'] }, status: :service_unavailable
        end
    rescue StandardError => e
        render json: { errors: ["Error fetching address: #{e.message}"] }, status: :internal_server_error
    end

    private

    def set_contact
        @contact = @current_user.contacts.find(params[:id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: ['Contact not found'] }, status: :not_found
    end

    def contact_params
        params.require(:contact).permit(:name, :tax_number, :phone, :address_name, :address_number, :address_complement, :postal_code, :latitude, :longitude)
    end
end
