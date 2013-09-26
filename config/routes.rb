Www::Application.routes.draw do
  root :to => 'root#index'
  get 'browse/:section', to: 'root#section'
  get ':slug', to: 'root#article'


end
