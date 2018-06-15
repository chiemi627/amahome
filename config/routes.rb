Rails.application.routes.draw do
	root 'purchase_items#list'

  get 'purchase_items/list'
  get 'purchase_items/add'
	post 'purchase_items/agent'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
