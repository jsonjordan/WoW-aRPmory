Rails.application.routes.draw do
  require 'sidekiq/web'

  root 'home#home'

  get '/user/:user_battletag/characters/select' => 'character#select', as: 'character_select'
  post '/user/:user_battletag/characters/update' => 'character#update', as: 'character_update'
  get '/user/:user_battletag/characters/:character_uid/show' => 'character#show', as: 'character_show'
  get '/user/:user_battletag/characters/user_index' => 'character#user_index', as: 'user_character_index'
  get '/user/:user_battletag/characters/:character_uid/todays_images' => 'character#todays_images', as: 'todays_images'
  post '/user/:user_battletag/characters/:character_uid/save_current_images' => 'character#save_current_images', as: 'save_current_images'
  get '/user/:user_battletag/characters/:character_uid/select_body_image' => 'character_image#select_body_image', as: 'select_body_image'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }


    mount Sidekiq::Web => '/sidekiq'


end
