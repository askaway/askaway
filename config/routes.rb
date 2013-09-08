Askaway::Application.routes.draw do
  root to: 'pages#another_page'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :questions do
    # resources :answers, only: [:index, :show], shallow: true
  end


  get 'another_page', to: 'pages#another_page'
  get 'styles', to: 'pages#styles'

end
