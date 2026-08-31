Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
       # Autenticación
       post "/login",    to: "auth#login"
       post "/register", to: "auth#register"
       post '/password/forgot', to: 'auth#forgot_password'
       post '/password/reset',  to: 'auth#reset_password'
       get   "/me", to: "auth#me"
       patch "/me", to: "auth#update_me"
       get "/dashboard", to: "dashboard#index"

      # Recursos
      resources :juegos,   only: [ :index, :show ]
      resources :alumnos, only: [ :index, :show, :create, :update, :destroy ] do
    member do
       get :estadisticas
    end
      end
      resources :sesiones,  only: [ :index, :create ]
      resources :users,     only: [ :index, :update ]
    end
  end
end
