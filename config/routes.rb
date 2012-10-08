Vad::Application.routes.draw do
  root :to => "import_declarations#index"

  devise_for :users, :controllers => {
    :registrations => 'users/registrations'
  }
  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  resources :import_declarations do
    put :import, :on => :member
    post :import_all, :on => :collection
    post :delete_imported, :on => :collection
  end

  resources :declarations do
    get :datatable, :on => :collection
    get :download, :on => :collection
  end
end
