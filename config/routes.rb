IpoWeb::Application.routes.draw do
  root to: "home#index"

  resources :projects_setup, path: "/projects/setup", only: [:index, :show, :update]
  resources :projects do
    resources :project_media, as: 'media', path: 'media', only: [:create]
  end
  resources :project_media, only: [:show, :destroy]
  resources :project_sessions

  resources :students_setup, path: "/students/setup", only: [:index, :show, :update]
  resources :students 

  resources :customer_sessions
  resources :customers do
    collection do
      get :access_denied
    end
  end

  match "login", controller: "CustomerSessions", action: "new", as: "login"
  match "logout", controller: "CustomerSessions", action: "destroy", as: "logout"
  match "access_denied", controller: "Customers", action: "access_denied", as: "access_denied"

  mount Refinery::Core::Engine, at: '/'
end
