Www::Application.routes.draw do
  resources :newsletters, only: [:index, :create]

  root :to => 'root#index'

  get "search", to: "search#perform"

  urlMaps = YAML.load_file("#{Rails.root.to_s}/config/url-mapping.yml")
  urlMaps.each do |item|
    get "#{item['url']}", as: "#{item['slug'].gsub('-','_')}_page", to: 'root#page', :slug => item['slug']
  end

  get "newsletters", as: "newsletters", to: 'root#newsletters'
  get "culture/collection", as: "culture_collection", to: 'root#culture_collection'
  get "events/previous", as: "previous_events_section", to: "root#previous_events"
  get "lunchtime-lectures", as: "lunchtime_lectures_section", to: "root#lunchtime_lectures"
  get "nodes/news", as: 'node_news', to: 'root#node_news_list'

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

    get "#{section_slug}", as: "#{event_type}_section", to: "root#events_list", :section => "events", :event_type => event_type

    get "#{section_slug}/module", as: "#{event_type}_list_module", to: "root#events_list_module", :section => "events", :event_type => event_type

    get "#{section_slug}/:slug", as: "#{event_type}_article", to: "root#events_article", :section => "events", :event_type => event_type

    get "#{section_slug}/:slug/module", as: "#{event_type}_module", to: "root#events_module", :section => "events", :event_type => event_type

    get "#{section_slug}/:slug/badge", as: "#{event_type}_badge", to: 'root#badge', :section => "events", :event_type => event_type
  end

  [:about, :get_involved, :learning].each do |section|
    slug = section.to_s.dasherize
    get "#{slug}", as: "#{section}_section", to: 'root#section', section: slug
  end

  get "courses/:slug/:date", as: 'course_instance', to: 'root#course_instance'

  get 'tags/*tag', to: 'tag#index'
  get 'tags/', to: 'tag#index'

  get ":slug", as: "page", to: 'root#page'

end
