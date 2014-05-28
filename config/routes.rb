Askaway::Application.routes.draw do
  get "answers/show"

  root to: 'questions#trending'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :questions, only: [:show, :new, :create]

  get 'about', to: redirect('/')
  get 'new_questions', to: 'questions#new_questions'

end
