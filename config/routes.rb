Www::Application.routes.draw do
  root :to => 'root#index'
  
  [:blog, :news].each do |section|
    get "#{section}", to: 'root#section', as: "#{section}_section", :section => section.to_s
    get "#{section}/:slug", as: "#{section}_article", to: 'root#article'
  end  

end
