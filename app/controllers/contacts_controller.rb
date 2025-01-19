class ContactsController < ApplicationController
    before_action :authorize
    before_action :set_contact, only: [:show, :update, :destroy]

    def index
        contacts = @current_user.contacts
        contacts = contacts.where('LOWER(name) LIKE ? OR LOWER(tax_number) LIKE ?', "%#{params[:query].downcase}%", "%#{params[:query].downcase}%") if params[:query].present?
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
