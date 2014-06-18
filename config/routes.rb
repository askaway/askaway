Askaway::Application.routes.draw do
  root to: 'questions#trending'

  devise_for :users, skip: :registrations, :path => '', :path_names => { :sign_in => "log_in", :sign_out => "log_out"}
  # Skipping registration and adding paths here in order to remove 'cancel' option
  as :user do
    get 'create_an_account' => 'devise/registrations#new', as: :new_user_registration
    post 'create_an_account' => 'devise/registrations#create', as: :user_registration
  end
  ActiveAdmin.routes(self)

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :users, only: :show do
    collection do
      get :edit
      patch :update
    end
  end

  resources :questions, only: [:show, :new, :create] do
    resources :comments, only: :create
    resources :votes, only: :create
  end
  get 'new_questions', to: 'questions#new_questions'

  resources :parties, only: :show do
    member do
      get :new_members
      post :invite_members
      get :invited_members
      get :walkthrough
    end
  end

  resources :invitations, only: :show
end
