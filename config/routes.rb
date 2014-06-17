require 'sidekiq/web'

IpoWeb::Application.routes.draw do

  authenticated :login do
    root :to => "dashboards#index"
  end

  devise_for :logins, class_name: "Login"

  devise_scope :login do
    post 'logins/sign_up'  => "devise/registrations#create"
    get 'logins/sign_in' => 'devise/sessions#new'
    post 'logins/sign_in' => 'devise/sessions#create'
    get 'logins/sign_out' => 'devise/sessions#destroy'
    get 'logins/edit' => 'devise/registrations#edit', as: 'edit_login_registration'
    put 'logins/:id' => 'devise/registrations#update', as: 'login_registration'
  end

  resources :projects_setup, path: "/projects/setup", only: [:index, :show, :update, :edit]
  resources :projects do
    resources :project_media, as: 'media', path: 'media', only: [:create]
  end
  resources :project_media, only: [:show, :destroy]

  match '/home/autocomplete' => "home#autocomplete"
  match '/search' => 'home#wide_search', :as => :wide_search
  match '/autocomplete' => 'home#elastic_autocomplete'
  resources :students_setup, path: "/students/setup", only: [:index, :show, :update]
  get '/students_setup/project_sessions/:project' => 'students_setup#project_sessions'
  get '/projects_setup/application_deadline/:id' => 'projects_setup#application_deadline'

  resources :students do
    get 'donate' => 'students#donate', :as => :donate_form
    post 'donating' => 'students#donating', :as => :donating
  end
  post 'apply' => 'students#apply', :as => :apply
  
  resources :dashboards, only: [:index]
  resources :sessions
  get '/unique/:model/:attribute/:value' => 'uniqueness#validate', constraints: { value: /[^\/?]+/ }

  put "dashboards/update_login" => "dashboards#update_login"

  resources :donations, path: "/donations", only: [:new, :create]
  get '/donate' => 'donations#new'

  mount Sidekiq::Web, at: '/sidekiq'
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
