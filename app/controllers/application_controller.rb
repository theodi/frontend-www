class ApplicationController < ActionController::Base

  protect_from_forgery
  
  def content_api
    content_api ||= GdsApi::ContentApi.new(
      Plek.current.find("contentapi"),
      CONTENT_API_CREDENTIALS
    )
  end
  
  def statsd
    statsd ||= Statsd.new("localhost").tap do |c|
      c.namespace = ENV['GOVUK_STATSD_PREFIX'].to_s
    end
  end
  
  
  def event_type(event)    
    url_map = {
      "open-data-challenge-series" => "challenge-series"
    }
    x = event.tag_ids.first
    url_map[x] || x
  end
  helper_method :event_type
  
  def event_path(event)
  	send("#{event_type(event).pluralize.gsub('-', '_')}_article_path", event.slug)
  end
  helper_method :event_path 
  
end