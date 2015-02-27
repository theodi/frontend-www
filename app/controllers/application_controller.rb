require 'artefact_retriever'

class RecordNotFound < StandardError
end

class ApplicationController < ActionController::Base
  include Slimmer::Template

  protect_from_forgery
  
  before_filter :cache_control
  
  def cache_control
    expires_in 4.hours, public: true
  end

  unless Rails.env.development?
    
    rescue_from GdsApi::TimedOutException, with: :error_500
    rescue_from GdsApi::EndpointNotFound, with: :error_500
    rescue_from GdsApi::HTTPErrorResponse, with: :error_500
    rescue_from ArtefactRetriever::RecordArchived, with: :error_410
    rescue_from ArtefactRetriever::UnsupportedArtefactFormat, with: :error_404
    rescue_from RecordNotFound, with: :error_404
    rescue_from GdsApi::HTTPNotFound, with: :error_404

    def error_404; error 404; end
    def error_410; error 410; end
    def error_500(e); error(500, e); end
    def error_503(e); error(503, e); end

    def error(status_code, exception = nil)
      if exception && ENV['QUIRKAFLEEG_AIRBRAKE_KEY']
        notify_airbrake(exception)
      end
      respond_to do |format|
        format.html { render status: status_code, text: "", layout: nil  }
        format.json { render status: status_code, json: { status: status_code } }
      end
    end

  end


  def content_api
    @content_api ||= GdsApi::ContentApi.new(
      Plek.current.find("contentapi"),
      CONTENT_API_CREDENTIALS
    )
  end
  helper_method :content_api

  def statsd
    statsd ||= Statsd.new("localhost").tap do |c|
      c.namespace = ENV['GOVUK_STATSD_PREFIX'].to_s
    end
  end
  helper_method :statsd


  def event_type(event)
    url_map = {
      "open-data-challenge-series" => "challenge-series"
    }
    x = event.details.event_type || "event"
    url_map[x] || x
  end
  helper_method :event_type
  
  def event_path(event)
  	send("#{event_type(event).pluralize.gsub('-', '_')}_article_path", event.slug)
  end
  helper_method :event_path 
  
end
