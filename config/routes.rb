Rails.application.routes.draw do
  require 'sidekiq/web'

  root 'home#home'

  get '/user/:user_battletag/characters/select' => 'character#select', as: 'character_select'
  post '/user/:user_battletag/characters/update' => 'character#update', as: 'character_update'
  get '/user/:user_battletag/characters/:character_uid/show' => 'character#show', as: 'character_show'
  get '/user/:user_battletag/characters/user_index' => 'character#user_index', as: 'user_character_index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }


    mount Sidekiq::Web => '/sidekiq'


end
