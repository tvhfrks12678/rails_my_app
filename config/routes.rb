Rails.application.routes.draw do
  root 'static_pages#home'
  get '/rhyme', to: 'static_pages#rhyme'
  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :quizzes
  resources :answers, only: [:create]
end
