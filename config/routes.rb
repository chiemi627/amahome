Rails.application.routes.draw do
	root 'purchase_items#list'

	get '/list', to: 'purchase_items#list'
  get '/add', to: 'purchase_items#add'
	post '/agent(.:format)', to: 'purchase_items#agent'
	get '/callback', to: 'purchase_items#callback'
	post '/callback', to: 'purchase_items#callback'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
