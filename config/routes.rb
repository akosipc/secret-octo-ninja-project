Gcommit::Application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }, skip: [:sessions, :registrations, :passwords] do
    delete 'users/sign_out' => 'devise/sessions#destroy', as: 'destroy_user_session'
  end

  root to: 'pages#index'
end
