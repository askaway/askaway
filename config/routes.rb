Askaway::Application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)

  root to: 'questions#trending'

  resources :questions, only: [:show, :new, :create]
  get 'new_questions', to: 'questions#new_questions'
end
