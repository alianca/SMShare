Smshare::Application.routes.draw do |map|

  # Rotas do Devise
  # TODO atualizar isso quando a DSL de rotas do Devise 1.1 estiver estavel
  devise_for :users, :path => "/", :path_names => { :sign_in => "login", :sign_out => "logout", :password => "login/esqueci_senha" }, :skip => [:registration]    
  devise_for :users, :path => "cadastro", :path_names => { :sign_up => "" }, :skip => [:sessions, :password], :controllers => { :registrations => "registrations" }  
  devise_scope :user do
    post "cadastro/valida_campo" => "registrations#validate_field"
  end
  
  resources :arquivos, :as=> :user_files, :controller => :user_files do
    member do
      get :download
      get :example
      match :download_box
    end
    
    collection do
      get :upload_remoto, :action => :remote_upload, :as => :remote_upload
      get :categorizar, :action => :categorize, :as => :categorize
      post :update_categories
      get :links
    end
  end
  
  resource :painel, :as=> :user_panel, :controller => :user_panel, :only => [:show, :destroy, :edit, :create] do
    member do
      get :manage
      post :move
      post :rename
      post :compress
      post :decompress
      match :customize
    end
    
    resource :relatorios, :as => :reports, :controller => :reports, :only => [:show]
  end
  
  resources :smsearch, :controller => :search, :as => :search, :only => [:index]
  
  namespace :admin do
    resources :news
  end
  
  resources :comments, :only => [:create, :destroy]
  
  resources :news, :only => [:index, :show]
  
  resources :guide, :only => [:index]
  
  resources :faq, :only => [:index]
  
  resources :caixa_download, :controller => :box_styles, :only => [:create] do
    collection do
      post :set_default
      get  :template, :action => :generate_javascript
    end
  end
  
  resources :box_images, :only => [:create] do
    collection do
      post :set_default
    end
  end
  
  root :to => "home#index"

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
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
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
