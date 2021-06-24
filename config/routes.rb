Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :leagues, only: %i[index new create]


  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
