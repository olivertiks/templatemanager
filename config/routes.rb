Rails.application.routes.draw do
  resources :activities
  resources :settings
  resources :errors
  get 'error/api_not_found'
  get 'setup', :to => 'settings#setup'
  get 'setup/api', :to => 'settings#apisetup'
  get 'setup/rdp', :to => 'settings#rdpsetup'
  get 'setup/master', :to => 'settings#createmaster'
  get 'setup/done', :to => 'settings#finalized'
  patch 'setup/rdp', :to => 'settings#rdpinitialize'
  patch 'setup/api', :to => 'settings#apiupdate'
  resources :machines

put 'setstate/:id(.:format)', :to => 'machines#setstate', :as => :set_machine_state
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
