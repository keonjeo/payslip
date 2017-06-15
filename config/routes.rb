Rails.application.routes.draw do

  devise_for :admins, :controllers => {
      :sessions => 'admins/sessions'
  }

  devise_scope :admin do
    root to: 'admins/sessions#new'
  end

  resources :employees, :only => [:index, :new, :create]
  
end
