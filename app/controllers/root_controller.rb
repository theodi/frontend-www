require 'gds_api/helpers'
require 'gds_api/content_api'
require 'artefact_retriever'

class RecordNotFound < StandardError
end

class RootController < ApplicationController
  
  def index
    @title = "Welcome"
  end
  
  def section
    @section = params[:section].parameterize
    @artefacts = content_api.sorted_by(params[:section], "curated").results
    @title = params[:section].humanize.capitalize
    render "section.html"
  end
  
  def page
    artefact = ArtefactRetriever.new(content_api, Rails.logger, statsd).
                  fetch_artefact(params[:slug], params[:edition], nil, nil)
    
    @publication = PublicationPresenter.new(artefact)
    render "content/page"
  end
  
  def article    
    artefact = ArtefactRetriever.new(content_api, Rails.logger, statsd).
                  fetch_artefact(params[:slug], params[:edition], nil, nil)
                  
    @publication = PublicationPresenter.new(artefact)
    respond_to do |format|
      format.html do
        render "content/#{@publication.format}"
      end
      format.json do
        render :json => @publication.to_json
      end
    end
  end
  
end