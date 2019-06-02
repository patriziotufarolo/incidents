Rails.application.routes.draw do
  resources :tickets do
      resources :attachments
      get :children
  end

  resources :incidents do
      member do
          get :tickets
          get :leads
      end
  end

  devise_for :users

  root :to => 'incidents#index'
end
