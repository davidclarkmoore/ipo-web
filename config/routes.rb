IpoWeb::Application.routes.draw do

  resources :projects_setup, path: "/projects/setup", only: [:index, :show, :update]
  resources :projects
  

  root :to => "projects#index"

end
