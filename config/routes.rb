Www::Application.routes.draw do
  root :to => 'root#index'

  urlMaps = YAML.load_file("#{Rails.root.to_s}/config/url-mapping.yml")
  urlMaps.each do |item|
    get "#{item['url']}", as: "#{item['slug'].gsub('-','_')}_page", to: 'root#page', :slug => item['slug']
  end
  
  [:blog, :news, :jobs, :team, :case_studies, :courses, :creative_works, :start_ups, :nodes, :consultation_responses, :guides, :events].each do |section|
    section_slug = section.to_s.dasherize
    get "#{section_slug}", as: "#{section}_section", to: "root##{section}_list", :section => section_slug

    get "#{section_slug}/module", as: "#{section}_list_module", to: "root##{section}_list_module", :section => section_slug

    get "#{section_slug}/:slug", as: "#{section}_article", to: "root##{section}_article", :section => section_slug

    get "#{section_slug}/:slug/module", as: "#{section}_module", to: "root##{section}_module", :section => section_slug

    get "#{section_slug}/:slug/badge", as: "#{section}_badge", to: 'root#badge', :section => section_slug
  end  
  
  [:about, :get_involved, :learning, :whats_happening].each do |section|
    slug = section.to_s.dasherize
    get "#{slug}", as: "#{section}_section", to: 'root#section', section: slug 
  end
  
  get "courses/:slug/:date", as: 'course_instance', to: 'root#course_instance'

  get ":slug", as: "page", to: 'root#page'

end
