Rails.application.routes.draw do
  get 'purchase_items/list'

  get 'purchase_items/add'
	post 'purchase_items/add'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
