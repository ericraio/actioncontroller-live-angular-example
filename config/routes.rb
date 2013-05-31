# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".

# You can have the root of your site routed with "root"
# root 'welcome#index'

# Example of regular route:
#   get 'products/:id' => 'catalog#view'

# Example of named route that can be invoked with purchase_url(id: product.id)
#   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

# Example resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Example resource route with options:
#   resources :products do
#     member do
#       get 'short'
#       post 'toggle'
#     end
#
#     collection do
#       get 'sold'
#     end
#   end

# Example resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Example resource route with more complex sub-resources:
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', on: :collection
#     end
#   end

# Example resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end

BootstrapApp::Application.routes.draw do
  root :to => "home#index"

  devise_for :users, :controllers => {
    registrations: "users/registrations",
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get '/game/:slug' => 'games#show'



  get '/unfollow/user/:slug' => 'users#unfollow_user', as: :user_unfollow
  get '/follow/user/:slug' => 'users#follow_user', as: :user_follow
  get '/user/profile/edit' => 'users#edit_profile'
  post '/user/profile/update' => 'users#update_profile'


  post     '/posts'             => 'posts#create'
  get      '/posts/events'      => 'posts#events', as: 'event_post'
  get      '/posts/notify'      => 'posts#notify', as: 'notify_post'
  get      '/posts/new'         => 'posts#new'
  get      '/posts/feed'        => 'posts#feed', as: 'feed'
  get      '/posts/:slug/edit'  => 'posts#edit', as: 'edit_post'
  get      '/posts/:slug'       => 'posts#show', as: 'post'
  patch    '/posts/:slug'       => 'posts#update'
  put      '/posts/:slug'       => 'posts#update'
  delete   '/posts/:slug'       => 'posts#destroy'
  post     '/posts/:slug/like'  => 'posts#like', as: 'like_post'

  get '/:slug' => 'users#show'
end
