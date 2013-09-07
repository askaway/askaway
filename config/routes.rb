Askaway::Application.routes.draw do

  resources :questions


  get 'another_page', to: 'pages#another_page'
  
  root to: 'pages#index'
end
