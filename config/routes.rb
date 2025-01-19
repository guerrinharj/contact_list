Rails.application.routes.draw do
  post '/signup', to: 'auth#signup'
  post '/login', to: 'auth#login'
  post '/forgot_password', to: 'auth#forgot_password'

  # Example of a protected route
  get '/profile', to: 'users#profile', as: :profile
end
