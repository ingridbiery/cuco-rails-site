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

  resources :events, :except => :index

  resources :pronouns, :event_types
  resources :rooms, :periods, only: [:index, :edit, :update]
  resources :banners, only: [:edit, :update, :show]

  resources :cuco_sessions do
    resources :courses do
      resources :course_signups, except: [:index, :show]
    end
    resources :dates, only: [:show, :edit, :update]
    get 'memberships/add' => 'memberships#add'
    post 'memberships/add' => 'memberships#complete_add'
    resources :memberships, only: [:new, :create, :show, :edit, :update]
    resources :family_schedules, only: [:show]
    get :show_open_jobs
    get :show_on_call
    get :show_adults
    get :show_rosters
    get :show_all_signups
    get :show_volunteers
    get :show_away
    get :show_nametags
    get :show_fees_summary
    get :show_all_signups_first_name
    get :show_all_signups_last_name
    get :show_ceramics_numbers

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

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
