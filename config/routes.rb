Rails.application.routes.draw do
  resources :vendors, only: [:index]

  resources :categories, only: [:index], param: :url do
    resources :items, only: [:index]
    # 'categories/food-stuff/items'
  end

  resources :cart_items, only: [:create, :destroy, :update]

  namespace :vendors, path: ':vendor', as: :vendor do
    resources :items, only: [:index, :show]
  end

  # resources :users,
  #           only: [:new, :create, :show, :edit, :update],
  #           param: :slug do
  #   get "/cart", to: "cart_items#index"
  #   resources :orders, only: [:index, :create, :show]
  #   resources :items, only: [:new, :create, :edit, :update]
  # end
  #
  # namespace :admin do
  #   get "/dashboard", to: "users#show"
  #   resources :items
  #   resources :orders, only: [:index, :update]
  # end
  #
  # resources :artists, only: [:index, :show], param: :slug

  get "/cart", to: "cart_items#index"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
  get "/admin_dashboard", to: "home#admin_dashboard"
  get "/platform_dashboard", to: "home#platform_dashboard"
  # get "/categories_2", to: "categories#index_2"
  root "home#index"
end
