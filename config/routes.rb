Rails.application.routes.draw do
  post '/signup', to: 'auth#signup'
  post '/login', to: 'auth#login'
  post '/forgot_password', to: 'auth#forgot_password'
  delete '/delete_account', to: 'auth#delete_account'

  get '/profile', to: 'users#profile', as: :profile
end
