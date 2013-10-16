Www::Application.routes.draw do
  root :to => 'root#index'
  
  [:blog, :news, :jobs, :team, :case_studies, :courses, :creative_works, :procurement, :organizations, :nodes,
    :consultation_responses, :guides].each do |section|
    section_slug = section.to_s.dasherize
    get "#{section_slug}", to: 'root#list', as: "#{section}_section", :section => section_slug
    get "#{section_slug}/:slug", as: "#{section}_article", to: 'root#article'

    get "#{section_slug}/:slug/badge", as: "#{section}_badge", to: 'root#badge'
  end  
  
  [:culture, :our_space, :dashboards, :membership, :certificates, :pg_certificate, :lunchtime_lectures, :newsroom, :virtual_tour].each do |page|
    slug = page.to_s.dasherize
    get "#{slug}", as: "page", to: 'root#page', slug: slug
  end
  
  [:about, :get_involved, :learning, :whats_happening, :news].each do |section|
    slug = section.to_s.dasherize
    get "#{slug}", as: "#{section}_section", to: 'root#section', section: slug 
  end
  
  match "start-ups", to: 'root#section', as: "organizations_section", section: "organizations"

end
