Rails.application.routes.draw do
  resources :activities
  resources :settings
  resources :errors
  get 'error/api_not_found'

  resources :machines

put 'setstate/:id(.:format)', :to => 'machines#setstate', :as => :set_machine_state
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
