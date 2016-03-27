Rails.application.routes.draw do
  get 'new_action', to: 'foreman_azure/hosts#new_action'
end
