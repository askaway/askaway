Askaway::Application.routes.draw do
  devise_for :users, skip: :registrations
  devise_scope :user do
    resource :registration,
             only: [:new, :create],
             path: 'users',
             path_names: { new: 'sign_up' },
             controller: 'devise/registrations'
  end
  ActiveAdmin.routes(self)

  root to: 'questions#trending'

  resources :questions, only: [:show, :new, :create] do
    resources :comments, only: [:create]
  end
  get 'new_questions', to: 'questions#new_questions'

  resources :users, only: [:update] do
    collection do
      get :edit
    end
  end
end
