Askaway::Application.routes.draw do
  get "answers/show"

  root to: 'questions#trending'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :questions, only: [:show, :new, :create] do
    collection do
      get :thanks
    end
  end

  get 'about', to: redirect('/')
end
