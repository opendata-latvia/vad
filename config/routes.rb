Vad::Application.routes.draw do
  root :to => "import_declarations#index"

  resources :import_declarations do
    put :import, :on => :member
    post :import_all, :on => :collection
    post :delete_imported, :on => :collection
  end

  resources :declarations do
    get :datatable, :on => :collection
  end
end
