Askaway::Application.routes.draw do

  get 'another_page', to: 'pages#another_page'
  
  root to: 'pages#index'
end
