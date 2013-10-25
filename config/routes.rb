Www::Application.routes.draw do
  root :to => 'root#index'

  urlMaps = YAML.load_file("#{Rails.root.to_s}/config/url-mapping.yml")
  urlMaps.each do |item|
    get "#{item['url']}", as: "#{item['slug'].gsub('-','_')}_page", to: 'root#page', :slug => item['slug']
  end
  
  get "culture/collection", as: "culture_collection", to: 'root#culture_collection'

  [:blog, :news, :jobs, :team, :case_studies, :courses, :creative_works, :start_ups, :nodes, :consultation_responses, :guides, :events, :culture].each do |section|
    section_slug = section.to_s.dasherize
    get "#{section_slug}", as: "#{section}_section", to: "root##{section}_list", :section => section_slug

    get "#{section_slug}/module", as: "#{section}_list_module", to: "root##{section}_list_module", :section => section_slug

    get "#{section_slug}/:slug", as: "#{section}_article", to: "root##{section}_article", :section => section_slug

    get "#{section_slug}/:slug/module", as: "#{section}_module", to: "root##{section}_module", :section => section_slug

    get "#{section_slug}/:slug/badge", as: "#{section}_badge", to: 'root#badge', :section => section_slug
  end  
  
  [:lunchtime_lectures, :meetups, :research_afternoons, :challenge_series, :roundtables, :workshops, :networking_events, :panel_discussions].each do |event_type|
    section_slug = event_type.to_s.dasherize
    
    get "#{section_slug}", as: "#{event_type}_section", to: "root#events_list", :section => "events"

    get "#{section_slug}/module", as: "#{event_type}_list_module", to: "root#events_list_module", :section => "events"

    get "#{section_slug}/:slug", as: "#{event_type}_article", to: "root#events_article", :section => "events"

    get "#{section_slug}/:slug/module", as: "#{event_type}_module", to: "root#events_module", :section => "events"
    
    get "#{section_slug}/:slug/badge", as: "#{event_type}_badge", to: 'root#badge', :section => "events"
  end
  
  [:about, :get_involved, :learning].each do |section|
    slug = section.to_s.dasherize
    get "#{slug}", as: "#{section}_section", to: 'root#section', section: slug 
  end
  
  get "courses/:slug/:date", as: 'course_instance', to: 'root#course_instance'

  get ":slug", as: "page", to: 'root#page'

end
