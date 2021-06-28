Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :leagues, only: %i[index new create]

  resources :pronos, only: %i[create]

  get ':username', to: 'users#show', as: :username
  get ':username/pronos', to: 'pronos#index', as: :username_pronos
  get ':username/pronos/:scrapp_id', to: 'pronos#show', as: :username_pronos_scrapp
  get ':username/pronos/:scrapp_id/new', to: 'pronos#new', as: :username_pronos_scrapp_new

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
