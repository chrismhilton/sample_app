SampleApp::Application.routes.draw do

  # Application Routes
  # to show all routes use 'rake routes' command
  
  # (1) endows our sample application with all the actions needed for a RESTful Users resource (index, show, new ...)
  # along with a large number of named routes for generating user URLs (users_path, user_path(1), new_user_path ...)
  # (2) included nested route so that "/users/[:user_id]/microposts" shows all the microposts for user 1
  # which adds index action to microposts controller and user_microposts path
  # (3) added following/followers actions to the Users controller giving us URLs like
  # "/users/[:id]/following" and "/users/[:id]/followers" and paths following_user and followers_user
  # member method means that the routes respond to URLs containing the user's id
  # since both pages will be showing data, use get to arrange for the URLs to respond to GET requests
  # using collection rather than member would respond to URLs like "/users/following" without user id
  resources :users do
    resources :microposts, :only => :index
    member do
      get :following, :followers
    end
  end

  # add routes for only those session actions required
  # using options hash with key of :only and array of actions
  resources :sessions, :only => [:new, :create, :destroy]

  # add routes for microposts - small subset as the interface to the
  # Microposts resource will run principally through the Users and Pages controllers
  resources :microposts, :only => [:create, :destroy]

  # add routes for user relationships
  resources :relationships, :only => [:create, :destroy]

  # add named routes for signin and signout
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  # Original routes
  #get "pages/home"
  #get "pages/contact"
  #get "pages/about"
  #get "pages/help"

  # Match also automatically creates named routes for use in the controllers and views:
  # about_path => '/about'
  # about_url  => 'http://localhost:3000/about'

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
  
  match '/signup',  :to => 'users#new'

  root :to => 'pages#home'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
