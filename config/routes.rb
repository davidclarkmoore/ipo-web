IpoWeb::Application.routes.draw do

  resources :projects_setup, path: "/projects/setup", only: [:index, :show, :update]
  resources :projects do
    resources :project_media, as: 'media', path: 'media', only: [:create]
  end
  resources :project_media, only: [:show, :destroy]

  root :to => "home#index"
end
