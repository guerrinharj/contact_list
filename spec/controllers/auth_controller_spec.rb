require 'rails_helper'

RSpec.describe AuthController, type: :controller do
    let(:user) { build(:user) }
    let(:existing_user) { create(:user) }

    describe 'POST #signup' do
        context 'with valid parameters' do
            it 'creates a new user' do
                post :signup, params: { user: { email: user.email, password: user.password, password_confirmation: user.password_confirmation } }

                expect(response).to have_http_status(:created)
                expect(JSON.parse(response.body)['message']).to eq('User created successfully')
            end
        end

        context 'with invalid parameters' do
            it 'does not create a user' do
                post :signup, params: { user: { email: '', password: 'short', password_confirmation: 'different' } }

                expect(response).to have_http_status(:unprocessable_entity)
                expect(JSON.parse(response.body)['errors']).not_to be_empty
            end
        end
    end

    describe 'POST #login' do
        context 'with valid credentials' do
            it 'logs in the user and returns success' do
                post :login, params: { user: { email: existing_user.email, password: existing_user.password } }

                expect(response).to have_http_status(:ok)
                expect(JSON.parse(response.body)['message']).to eq('Login successful')
                expect(JSON.parse(response.body)['user']['email']).to eq(existing_user.email)
            end
        end

        context 'with invalid credentials' do
            it 'returns unauthorized status' do
                post :login, params: { user: { email: existing_user.email, password: 'wrongpassword' } }

                expect(response).to have_http_status(:unauthorized)
                expect(JSON.parse(response.body)['errors']).to include('Invalid email or password')
            end
        end
    end

    describe 'POST #forgot_password' do
        context 'with a valid email' do
            it 'sends password reset instructions' do
                allow(UserMailer).to receive_message_chain(:forgot_password, :deliver_now)

                post :forgot_password, params: { user: { email: existing_user.email } }

                expect(response).to have_http_status(:ok)
                expect(JSON.parse(response.body)['message']).to eq('Password reset instructions sent to your email')
                expect(UserMailer).to have_received(:forgot_password).with(existing_user)
            end
        end

        context 'with an invalid email' do
            it 'returns not found status' do
                post :forgot_password, params: { user: { email: 'nonexistent@example.com' } }

                expect(response).to have_http_status(:not_found)
                expect(JSON.parse(response.body)['message']).to eq('Email not found')
            end
        end
    end

    describe 'DELETE #delete_account' do
        context 'with valid password and confirmation' do
            it 'deletes the user account and returns success' do
                delete :delete_account, params: {
                    user: {
                    email: existing_user.email,
                    password: existing_user.password,
                    password_confirmation: existing_user.password
                    }
                }

                expect(response).to have_http_status(:ok)
                expect(JSON.parse(response.body)['message']).to eq('Account deleted successfully')
            end
        end

        context 'with mismatched password confirmation' do
            it 'returns an unprocessable entity status' do
                delete :delete_account, params: {
                    user: {
                    email: existing_user.email,
                    password: existing_user.password,
                    password_confirmation: 'wrongconfirmation'
                    }
                }

                expect(response).to have_http_status(:unprocessable_entity)
                expect(JSON.parse(response.body)['errors']).to include('Password confirmation does not match')
            end
        end

        context 'with invalid credentials' do
            it 'returns an unauthorized status' do
                delete :delete_account, params: {
                    user: {
                    email: existing_user.email,
                    password: 'wrongpassword',
                    password_confirmation: 'wrongpassword'
                    }
                }

                expect(response).to have_http_status(:unauthorized)
                expect(JSON.parse(response.body)['errors']).to include('Invalid email or password')
            end
        end
    end
end
