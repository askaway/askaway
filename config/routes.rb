Askaway::Application.routes.draw do

  resources :questions


  get 'another_page', to: 'pages#another_page'
  get 'styles', to: 'pages#styles'

  root to: 'pages#another_page'
end
