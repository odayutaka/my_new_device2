Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
	namespace :manager do
	  devise_for :admins, controllers:{
	  	sessions: 'manager/admins/sessions',
	  	registrations: 'manager/admins/registrations',
	  	passwords: 'manager/admins/passwords'
  	}
  	get 'top' => 'admins#top'
  	get 'today' => 'orders#today'
    get 'members/:id/order' => 'orders#member', as: 'member_order'
  	resources :items
  	resources :members
  	resources :orders
  	resources :genres
	end

  namespace :public do
  	devise_for :members, controllers:{
	  	sessions: 'public/members/sessions',
	  	registrations: 'public/members/registrations',
	  	passwords: 'public/members/passwords'
  	}
  	patch 'leave' => 'members#update_status'
    get 'leave' => 'members#leave'
  	get 'thanks' => 'orders#thanks'
  	post 'confirm' => 'orders#confirm'
    get 'confirm' => 'orders#new'
    get 'about' => 'homes#about'
  	resources :items do
      resources :reviews, only:[:destroy]
    end
  	resources :members
  	resources :addresses
  	resources :cart_items
    resources :genres, only:[:show]
    resources :orders
    resources :cards
    resources :reviews, only:[:create]
	end

	root 'public/homes#top'
end
