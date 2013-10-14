Www::Application.routes.draw do
  root :to => 'root#index'
  
  [:blog, :news, :jobs, :team, :case_studies, :courses, :creative_works, :procurement, :organizations, :nodes,
    :consultation_response, :guides].each do |section|
    get "#{section}", to: 'root#section', as: "#{section}_section", :section => section.to_s
    get "#{section}/:slug", as: "#{section}_article", to: 'root#article'
  end  
  
  [:culture, "our-space", :dashboards, :membership, :certificates, "pg-certificate", "lunchtime-lectures", :newsroom].each do |page|
    get "#{page}", as: "page", to: 'root#page', slug: page.to_s
  end
  
  match "start-ups", to: 'root#section', as: "organizations_section", section: "organizations"
  match "consultation-responses", to: 'root#section', as: "consultation_response_section", section: "consultation-response"

end
