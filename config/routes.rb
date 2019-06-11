Rails.application.routes.draw do
  resources :tickets, :except => [:edit] do
      resources :attachments, :except => [:edit]
      resources :comments
      resources :observables, :except => [:edit]
      member do
        get :children
        get :tree
      end
  end

  resources :incidents, :except => [:edit] do
      member do
          get :tickets
          get :leads
          get :observables
          get :attachments
          get :tree
      end
  end

  devise_for :users

  scope "/admin" do
    resources :users, :except => [:new, :show, :edit]
  end

  root :to => 'incidents#index'
end
