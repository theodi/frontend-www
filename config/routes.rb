Www::Application.routes.draw do
  root :to => 'root#index'
  get 'browse/:section', to: 'root#section'

end
