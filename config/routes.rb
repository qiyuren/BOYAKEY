Rails.application.routes.draw do

  post 'likes/:post_id/create' => 'likes#create'
  post 'likes/:post_id/destroy' => 'likes#destroy'

  get 'login_form' => 'users#login_form'
  post 'login' => 'users#login'
  post 'logout' => 'users#logout'
  get 'users/index' =>'users#index'
  get 'signup' => 'users#new'
  post 'users/create' => 'users#create'
  get 'users/:id' => 'users#show'
  get 'users/:id/edit' => 'users#edit'
  post 'users/:id/update' => 'users#update'

  get 'tweets/index' => 'tweets#index'
  post 'tweets/index/search' => 'tweets#search'
  get 'tweets/new' => 'tweets#new'
  post 'tweets/create' => 'tweets#create'
  get 'tweets/:id' => 'tweets#show'
  get 'tweets/:id/edit' => 'tweets#edit'
  post 'tweets/:id/update' => 'tweets#update'
  get 'tweets/:id/destroy' => 'tweets#destroy'

  get '/' => 'home#top'
  get 'about' => 'home#about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
