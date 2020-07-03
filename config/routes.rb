# frozen_string_literal: true

Rails.application.routes.draw do
  # resources :members
  resource :members do
    patch '/:id/befriend/:friend_id', to: 'members#befriend', on: :member
    get '/:id', to: 'members#show', on: :member
    get '', to: 'members#index', on: :collection
    get '/search/:id', to: 'members#search'
  end
end
