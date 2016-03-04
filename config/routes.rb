Rails.application.routes.draw do
  root to: 'recipes#new'
  get '/create_recipe', controller: 'recipes', action: 'show'
end
