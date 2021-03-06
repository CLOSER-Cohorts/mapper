Rails.application.routes.draw do
  resources :sequences
  resources :sequences
  devise_for :users
  resources :topics
  resources :instruments, shallow: true do
    resources :questions do
      member do
        post :add_variable
        post :remove_variable
        post :set_topic
      end
    end
    resources :variables do
      member do
        post :add_question
        post :remove_question
        post :add_variable
        post :remove_variable
        post :set_topic
      end
    end
    resources :sequences do
      member do
        post :set_topic
      end
    end
    member do
      patch :import_qlist
      patch :import_from_caddies
      patch :import_variables
      patch :import_map
      patch :import_dv
      patch :import_linking
    end
    collection do 
      post :batch
      get :batch
    end
    get :mapping
    get :dv
    get :linking
    get :question_topics, path: 'topic-q'
    get :variable_topics, path: 'topic-v'
    get :mapper
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#index'

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

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
