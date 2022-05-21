Rails.application.routes.draw do
  root 'home#home'

  get '/user/:user_battletag/characters/select' => 'character#select', as: 'character_select'
  post '/user/:user_battletag/characters/update' => 'character#update', as: 'character_update'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

end
