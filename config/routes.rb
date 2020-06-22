Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
	namespace :manager do
	  devise_for :admins, controllers:{
	  	sessions: 'manager/admins/sessions',
	  	registrations: 'manager/admins/registrations',
	  	passwords: 'manager/admins/passwords'
  	}
  	get 'top' => 'admins#top'
  	get 'orders/today' => 'orders#today'
  	resources :items
  	resources :members
  	resources :orders
  	resources :genres
  	resources :order_details, only: [:update]
	end

  namespace :public do
  	devise_for :members, controllers:{
	  	sessions: 'public/members/sessions',
	  	registrations: 'public/members/registrations',
	  	passwords: 'public/members/passwords'
  	}
  	patch 'leave' => 'members#update_status'
    get 'leave' => 'members#leave'
  	get 'orders/thanks' => 'orders#thanks'
  	post 'orders/confirm' => 'orders#confirm'
    get 'orders/member' => 'orders#member'
    get 'about' => 'homes#about'
  	resources :items
  	resources :members
  	resources :addresses
  	resources :cart_items
    resources :genres, only:[:show]
    resources :orders
    resources :cards
	end

	root 'public/homes#top'
end
