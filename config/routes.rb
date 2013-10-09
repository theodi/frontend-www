Www::Application.routes.draw do
  root :to => 'root#index'
  get ':section', to: 'root#section'
  get ':section/:slug', to: 'root#article'


end
