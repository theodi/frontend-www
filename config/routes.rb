Www::Application.routes.draw do

  # Permenant redirects
  redirects = YAML.load_file("#{Rails.root.to_s}/config/redirects.yml")
  redirects.each do |from, to|
    match from => redirect(to)
  end

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

  # Load variants of start-ups lists
  get "current-start-ups", as: "start_ups_current_section", to: "root#start_ups_current_list", :section => "start_ups"
  get "graduated-start-ups", as: "start_ups_graduated_section", to: "root#start_ups_graduated_list", :section => "start_ups"

  [2016].each do |year|
    get "summit/#{year}/speakers", as: 'summit_speaker_list', to: 'root#summit_speaker_list', section: "summit_speaker_#{year}"
    get "summit/#{year}/speakers/:slug", as: 'summit_speaker_article', to: 'root#summit_speaker_article', section: "summit_speaker_#{year}"
  end

  [:blog, :news, :jobs, :team, :case_studies, :courses, :creative_works, :start_ups, :nodes, :consultation_responses, :guides, :events, :culture].each do |section|
    section_slug = section.to_s.dasherize
    get "#{section_slug}", as: "#{section}_section", to: "root##{section}_list", :section => section_slug

    get "#{section_slug}/module", as: "#{section}_list_module", to: "root##{section}_list_module", :section => section_slug

    get "#{section_slug}/:slug", as: "#{section}_article", to: "root##{section}_article", :section => section_slug

    get "#{section_slug}/:slug/module", as: "#{section}_module", to: "root##{section}_module", :section => section_slug

    get "#{section_slug}/:slug/badge", as: "#{section}_badge", to: 'root#badge', :section => section_slug
  end

  [:lunchtime_lectures, :meetups, :research_afternoons, :challenge_series, :roundtables, :workshops, :networking_events, :panel_discussions, :summit].each do |event_type|
    section_slug = event_type.to_s.dasherize

    get "#{section_slug}", as: "#{event_type}_section", to: "root#events_list", :section => "events", :event_type => event_type

    get "#{section_slug}/module", as: "#{event_type}_list_module", to: "root#events_list_module", :section => "events", :event_type => event_type

    get "#{section_slug}/:slug", as: "#{event_type}_article", to: "root#events_article", :section => "events", :event_type => event_type

    get "#{section_slug}/:slug/module", as: "#{event_type}_module", to: "root#events_module", :section => "events", :event_type => event_type

    get "#{section_slug}/:slug/badge", as: "#{event_type}_badge", to: 'root#badge', :section => "events", :event_type => event_type
  end

  [:about, :get_involved, :learning, :network, :our_focus, :publications, :our_network].each do |section|
    slug = section.to_s.dasherize
    get "#{slug}", as: "#{section}_section", to: 'root#section', section: slug
  end

  get "courses/:slug/:date", as: 'course_instance', to: 'root#course_instance'

  get 'tags/*tag', to: 'tag#index'
  get 'tags/', to: 'tag#index'

  get ":slug", as: "page", to: 'root#page'

end
