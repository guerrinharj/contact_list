require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
    let(:user) { create(:user) }
    let(:contact) { create(:contact, user: user) }

    before do
        request.headers['Email'] = user.email
        request.headers['Password'] = user.password
    end

    describe 'GET #index' do
        it 'returns all contacts for the current user' do
            create_list(:contact, 3, user: user)
            get :index
            expect(response).to have_http_status(:ok)
        end

        it 'filters contacts by name' do
            create(:contact, name: 'John Doe', user: user)
            create(:contact, name: 'Jane Smith', user: user)
            get :index, params: { name: 'John' }
            expect(response).to have_http_status(:ok)
        end

        it 'filters contacts by tax_number' do
            get :index, params: { tax_number: '14268823786' }
            expect(response).to have_http_status(:ok)
        end
    end

    describe 'GET #show' do
        it 'returns the specified contact' do
            get :show, params: { id: contact.id }
            expect(response).to have_http_status(:ok)
        end

        it 'returns not found for an invalid contact ID' do
            get :show, params: { id: 999 }
            expect(response).to have_http_status(:not_found)
        end
    end

    describe 'POST #create' do
        it 'returns created status for valid parameters' do
            post :create, params: { contact: attributes_for(:contact) }
            expect(response).to have_http_status(:created)
        end

        it 'returns unprocessable_entity status for invalid parameters' do
            post :create, params: { contact: attributes_for(:contact, name: '') }
            expect(response).to have_http_status(:unprocessable_entity)
        end
    end

    describe 'PUT #update' do
        it 'returns ok status for valid parameters' do
            put :update, params: { id: contact.id, contact: { name: 'Updated Name' } }
            expect(response).to have_http_status(:ok)
        end

        it 'returns unprocessable_entity status for invalid parameters' do
            put :update, params: { id: contact.id, contact: { tax_number: '' } }
            expect(response).to have_http_status(:unprocessable_entity)
        end
    end

    describe 'DELETE #destroy' do
        it 'returns ok status for valid contact deletion' do
            delete :destroy, params: { id: contact.id }
            expect(response).to have_http_status(:ok)
        end

        it 'returns not found for an invalid contact ID' do
            delete :destroy, params: { id: 999 }
            expect(response).to have_http_status(:not_found)
        end
    end

    describe 'GET #find_address' do
        context 'when postal code is valid' do
            before do
                allow(Net::HTTP).to receive(:get_response).and_return(
                instance_double(
                    Net::HTTPSuccess,
                    is_a?: true,
                    body: { cep: '22060-021' }.to_json
                )
                )
            end

            it 'returns address details for a valid postal code' do
                get :find_address, params: { postal_code: '22060-021' }
                expect(response).to have_http_status(:ok)
                expect(JSON.parse(response.body)['cep']).to eq('22060-021')
            end
        end

        context 'when postal code is invalid' do
            before do
                allow(Net::HTTP).to receive(:get_response).and_return(
                instance_double(
                    Net::HTTPResponse,
                    is_a?: false
                )
                )
            end

            it 'returns an error for an invalid postal code' do
                get :find_address, params: { postal_code: '00000-000' }
                expect(response).to have_http_status(:service_unavailable)
            end
        end
    end
end
