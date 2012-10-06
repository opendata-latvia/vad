Vad::Application.routes.draw do
  root :to => "import_declarations#index"

  resources :import_declarations do
    put :import, :on => :member
  end
end
