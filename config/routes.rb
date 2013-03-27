Toolman::Application.routes.draw do  
  resources :work_orders, only: [:show] do
    collection do 
      get :issue, to: 'work_orders#new_issue'
      post :issue, to: 'work_orders#create_issue'
      get :issues, to: 'work_orders#index_issue'

      get :receive, to: 'work_orders#new_receive'
      post :receive, to: 'work_orders#create_receive'
      get :receives, to: 'work_orders#index_receive'

      get :grind, to: 'work_orders#new_grind'
      post :grind, to: 'work_orders#create_grind'
      get :grinds, to: 'work_orders#index_grind'
      
      get :tune, to: 'work_orders#new_tune'
      post :tune, to: 'work_orders#create_tune'
      get :tunes, to: 'work_orders#index_tune'
    end
  end

  resources :tool_boms do
    collection do
      get  "import", to: "tool_boms#new_import"
      post "import", to: "tool_boms#create_import"
    end
  end

  resources :tool_parts do 
    collection do
      get  "import", to: "tool_parts#new_import"
      post "import", to: "tool_parts#create_import"
    end
  end

  resources :tunning_diagrams  do
    get 'scan', on: :collection
  end

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => 'home#index'
  devise_for :users
  resources :users
end
