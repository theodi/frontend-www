Www::Application.routes.draw do
  root :to => 'root#index'
  
  [:blog, :news, :jobs, :team, :case_studies, :courses, :creative_works, :procurement, :start_up, :nodes,
    :consultation_responses, :guides].each do |section|
    section_slug = section.to_s.dasherize
    get "#{section_slug}", as: "#{section}_section", to: "root##{section}_list", :section => section_slug

    get "#{section_slug}/module", as: "#{section}_list_module", to: "root##{section}_list_module", :section => section_slug

    get "#{section_slug}/:slug", as: "#{section}_article", to: 'root#article', :section => section_slug

    get "#{section_slug}/:slug/module", as: "#{section}_module", to: "root##{section}_module", :section => section_slug

    get "#{section_slug}/:slug/badge", as: "#{section}_badge", to: 'root#badge', :section => section_slug
  end  
  
  [:about, :get_involved, :learning, :whats_happening, :news].each do |section|
    slug = section.to_s.dasherize
    get "#{slug}", as: "#{section}_section", to: 'root#section', section: slug 
  end
  
  get ":slug", as: "page", to: 'root#page'

end
