Rails.application.routes.draw do
  devise_for :users
  resources :activities
  resources :settings
  resources :errors

  # Route for API error(s)
  get 'error/api_not_found'

  # Routes to Setup views
  get 'setup', :to => 'setup#index'
  get 'setup/api', :to => 'setup#apisetup'
  get 'setup/rdp', :to => 'setup#rdpsetup'
  get 'setup/done', :to => 'setup#finalized'
  get 'setup/master', :to => 'setup#createmaster'
  get 'setup/locked', :to => 'setup#locked'

  # Routes for Setup actions
  patch 'setup/rdp', :to => 'setup#rdpinitialize'
  patch 'setup/master', :to => 'setup#masterinitialize'
  post 'setup/master', :to => 'setup#masterinitialize'
  patch 'setup/api', :to => 'setup#apiupdate'
  patch 'setup/lock', :to => 'setup#lock'

  resources :machines

  root 'machines#index'
put 'setstate/:id(.:format)', :to => 'machines#setstate', :as => :set_machine_state
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
