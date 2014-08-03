Askaway::Application.routes.draw do
  root to: 'questions#trending'

  devise_for :users, skip: :registrations, :path => '',
             :path_names => { :sign_in => "log_in", :sign_out => "log_out"},
             :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  # Skipping registration and adding paths here in order to remove 'cancel' option
  as :user do
    get 'create_an_account' => 'devise/registrations#new', as: :new_user_registration
    post 'create_an_account' => 'devise/registrations#create', as: :user_registration
  end

  ActiveAdmin.routes(self)

  match '/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  resources :users, only: :show do
    collection do
      get :edit
      patch :update
      get :new_avatar
      patch :upload_avatar
      patch :select_avatar
    end
  end

  resources :questions, path: 'q', only: [:show, :new, :create] do
    resources :comments, only: :create
    resources :votes, only: :create
    resources :answers, only: :create
  end

  resources :comments, only: :destroy
  resources :votes, only: :destroy
  resources :answers, only: [:edit, :update] do
    member do
      get :history
    end
  end

  scope module: :admin do
    resources :embedded_topics, only: :index
  end

  scope '/rnz', module: :rnz_admin, as: 'rnz_admin' do
    get '/' => redirect('rnz/embedded_topics')
    resources :embedded_topics, except: [:destroy]
    resources :questions, only: [:edit, :update]
  end

  resources :embedded_topics, only: :show
  # get 'embedded_topics/admin', to: 'embedded_topics#admin'
  # resources :embedded_topics, only: :show

  get 'new_questions', to: 'questions#new_questions'
  get 'trending', to: 'questions#trending'
  get 'best', to: 'questions#best'

  resources :parties, only: :show, path: 'p' do
    member do
      get :invited_reps
      get :walkthrough
      get :new_avatar
      patch :upload_avatar
    end
    resources :invitations, only: [:new, :create]
  end

  resources :invitations, only: [:show, :destroy]

  get 'about', to: 'pages#about', as: 'about'
end
