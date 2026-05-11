Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Autenticación
       post '/login',    to: 'auth#login'
       post '/register', to: 'auth#register'
       get  '/me',       to: 'auth#me'

      # Recursos
      resources :juegos,   only: [:index, :show]
      resources :alumnos,  only: [:index, :show, :create, :update, :destroy]
      resources :sesiones,  only: [:index, :create]
      
    end
  end
end
