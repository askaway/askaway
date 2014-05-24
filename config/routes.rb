Askaway::Application.routes.draw do
  get "answers/show"

  root to: 'pages#another_page'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :questions do
    member do
      post   'vote_for'
    end
    collection do
      get :thanks
    end
    # resources :answers, only: [:index, :show], shallow: true
  end
  resources :answers, only: :show


  get 'another_page', to: 'pages#another_page'
  get 'styles', to: 'pages#styles'
  get 'about', to: redirect('/')
end
