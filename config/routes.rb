Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Notification list is at /users/notification_list in the users controller
  # as show_notification_list
  get 'users/notification_list' => 'users#show_notification_list'

  devise_for :users, :path_names => { :sign_up => "register" },
             :controllers => { :omniauth_callbacks => "omniauth_callbacks",
                               registrations: 'registrations' }

  # others are handled by devise
  resources :users, :only => [:index, :show, :destroy]

  # the calendar page url is /calendar. We get it through the
  # calendar controller, show method
  get 'calendar' => 'calendars#show'

  get 'families/show_emergency_contacts' => 'families#show_emergency_contacts'
  get 'families/show_member_directory' => 'families#show_member_directory'

  # RESTful resources for family and people models, i.e. /people/new, /families/edit, etc...
  resources :families do
    resources :people
  end

  resources :pronouns, :event_types
  resources :rooms, :periods, :only => [:index, :edit, :update]
  
  resources :cuco_sessions do
    resources :courses do
      resources :course_signups, except: [:index, :show]
    end
    resources :dates, only: [:show, :edit, :update]
    get 'memberships/add_member' => 'memberships#add_member'
    resources :memberships, only: [:new, :create, :show, :edit, :update] do
      get :show_schedule
    end
    get :show_open_jobs
    get :show_all_signups
    get :show_volunteers
    get :nametags
    get :show_fees_summary

    # make sure post works for membership show (since this is where we return from paypal)
    post "/memberships/:id" => "memberships#show"
    # a path for paypal to confirm that the payment has been processed
  end
  post "/paypal_hook" => "memberships#paypal_hook", as: :paypal_hook

  resources :course_roles


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
