IpoWeb::Application.routes.draw do
  root :to => "home#index"
  devise_for :logins do
    post 'logins/sign_up'  => "devise/registrations#create"
    get 'logins/sign_in' => 'devise/sessions#new'
    post 'logins/sign_in' => 'devise/sessions#create'
    get 'logins/sign_out' => 'devise/sessions#destroy'
  end

  resources :projects_setup, path: "/projects/setup", only: [:index, :show, :update]
  resources :projects do
    resources :project_media, as: 'media', path: 'media', only: [:create]
  end
  resources :project_media, only: [:show, :destroy]

  match '/home/autocomplete' => "home#autocomplete"

  resources :students_setup, path: "/students/setup", only: [:index, :show, :update]
  resources :students

  mount Refinery::Core::Engine, :at => '/'

  Refinery::Core::Engine.routes.draw do
    devise_scope :refinery_user do
      get "refinery/login", :to => "sessions#new", :as => :login
      get "refinery/logout", :to => "sessions#destroy", :as => :logout
      get "refinery/users/register" => 'users#new', :as => :new_signup
      post "refinery/users/register" => 'users#create', :as => :signup
    end

    devise_for :refinery_user, :class_name => 'Refinery::User',
               :path => "refinery/users",
               :controllers => { :registrations => 'refinery/users' },
               :skip => [:registrations],
               :path_names => { :sign_out => 'logout',
                                :sign_in => 'login',
                                :sign_up => 'register' }
  end
end
