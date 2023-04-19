Rails.application.routes.draw do
  devise_for :users
  
  resources :recipes do
    resources :recipe_foods, as: 'foods'
  end
  resources :public_recipes
  post 'toggle_public', to: 'recipes#toggle'


  resources :foods

  resources :shoppinglist, only: %i[index]

  get '/unauthorized', to: 'unauthorized#index'

  root "foods#index"
  end
