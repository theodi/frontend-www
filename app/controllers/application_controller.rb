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
  
end