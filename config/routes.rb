Smshare::Application.routes.draw do

  # Rotas do Devise
  # TODO atualizar isso quando a DSL de rotas do Devise 1.1 estiver estavel
  devise_for(
    :users,
    :path => "/",
    :path_names => {
      :sign_in => "login",
      :sign_out => "logout", :password => "login/esqueci_senha"
    },
    :skip => [:registration],
    :controllers => {
      :sessions => "sessions"
    }
  )

  devise_for(
    :users,
    :path => "cadastro",
    :path_names => {
      :sign_up => ""
    },
    :skip => [:sessions, :password],
    :controllers => {
      :registrations => "registrations"
    }
  )

  devise_scope :user do
    post "cadastro/valida_campo" => "registrations#validate_field"
  end

  resources :arquivos, {
    :as         => :user_files,
    :controller => :user_files
  } do
    collection do
      get  :categorizar, {
        :action => :categorize,
        :as     => :categorize
      }
      post :update_categories
      get  :links
    end
  end

  resources :uploads, {
    :as         => :user_files,
    :controller => :user_files,
    :only       => [:create]
  }

  resources :upload_remoto, {
    :as         => :remote_uploads,
    :controller => :remote_uploads,
    :only       => [:new, :create]
  }

  resource :painel, {
    :as         => :user_panel,
    :controller => :user_panel,
    :only       => [:show, :destroy, :edit, :create]
  } do
    member do
      get   :manage
      post  :move
      post  :rename
      post  :compress
      post  :decompress
      match :compression_state
      match :customize
    end

    resource :relatorios, {
      :as         => :reports,
      :controller => :reports,
      :only       => [:show]
    }

    resource :requisicao_de_pagamento, {
      :as         => :payment_requests,
      :controller => :payment_requests,
      :only       => [:show, :create]
    }

    resource :indicacoes, {
      :as         => :referrers,
      :controller => :referrers,
      :only       => [:show]
    }

    resource :pecas_publicitarias, {
      :as         => :advertising,
      :controller => :advertising,
      :only       => [:show, :create]
    }
  end

  resources :smsearch, {
    :controller => :search,
    :as         => :search,
    :only       => [:index]
  } do
    collection do
      get :opensearch
    end
  end

  namespace :admin do
    resources :noticias, {
      :as         => :news,
      :controller => "news",
      :except     => [:show]
    }
    resources :denuncias, {
      :as         => :user_file_reports,
      :controller => "user_file_reports"
    }
    resources :requisicoes_de_pagamento, {
      :as         => :payment_requests,
      :controller => :payment_requests,
      :only       => [:index, :create]
    }
    resources :usuarios, {
      :as         => :users,
      :controller => "users"
    } do
      member do
        post :block
        post :unblock
        post :toggle_admin
      end
    end

    resources :arquivos, {
      :as         => :user_files,
      :controller => "user_files"
    } do
      member do
        post :block
        post :unblock
      end
    end

    resources :comentarios, {
      :as         => :comments,
      :controller => "comments"
    } do
      member do
        post :block
        post :unblock
      end
    end
  end

  resources :comments, {
    :only => [:create, :destroy]
  }

  resources :answers, {
    :only => [:create, :destroy]
  }

  resources :imagens, {
    :as         => :user_file_images,
    :controller => "user_file_images",
    :only       => [:create, :destroy]
  }

  resources :noticias, {
    :as => :news,
    :controller => :news,
    :only => [:index, :show]
  }

  resources :guia_geral, {
    :as => :guide,
    :controller => :guide,
    :only => [:index]
  }

  resources :ciclo_pagamento, {
    :as => :cycles,
    :controller => :cycles,
    :only => [:index]
  }

  resources :lucre_mais, {
    :as => :optimization,
    :controller => :optimization,
    :only => [:index]
  }

  resources :vantagens, {
    :as => :advantages,
    :controller => :advantages,
    :only => [:index]
  }

  resources :faq, {
    :only => [:index]
  }

  resources :denunciar_abuso, {
    :as         => :report_abuse,
    :controller => "report_abuse",
    :only       => [:index]
  }

  resources :feeds, {
    :only   => [:index, :show],
    :format => :xml
  }

  resources :institucional, {
    :as         => :institutional,
    :controller => 'institutional',
    :only       => []
  } do
    collection do
      get :empresa, {
        :as     => :company,
        :action => :company
      }
      get :trabalhe_conosco, {
        :as     => :work,
        :action => :work
      }
      get :termos_de_uso, {
        :as     => :terms,
        :action => :terms
      }
      get :politica_de_privacidade, {
        :as     => :privacy,
        :action => :privacy
      }
    end
  end


  resources :caixa_download, {
    :controller => :box_styles,
    :only       => [:create]
  } do
    collection do
      post :set_default
      get  :template, {
        :action => :generate_javascript
      }
    end
  end

  resource :autorizacao, {
    :as         => :authorizations,
    :controller => "authorizations",
    :only       => [:new, :create, :show]
  }

  resources :box_images, {
    :only => [:create]
  } do
    collection do
      post :set_default
    end
  end

  resources :users, {
    :only => [:show, :edit, :update]
  } do
    collection do
      get :states_for_country
    end
  end

  match "/grid/*path" => "gridfs#serve"
  root :to => "home#index"

end
