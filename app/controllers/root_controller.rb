require 'gds_api/helpers'
require 'gds_api/content_api'
require 'artefact_retriever'

class RecordNotFound < StandardError
end

class RootController < ApplicationController
  
  def index
    @title = "Welcome"
  end
  
  def list
    @section = params[:section].parameterize
    @artefacts = content_api.sorted_by(params[:section], "curated").results
    @title = params[:section].humanize.capitalize
    render "list.html"
  end
  
  def section
    sections = YAML.load_file("#{Rails.root.to_s}/config/sections.yml")
    @section = sections[params[:section]]
    render "section/section"
  end
  
  def page
    artefact = ArtefactRetriever.new(content_api, Rails.logger, statsd).
                  fetch_artefact(params[:slug], params[:edition], nil, nil)
    
    @publication = PublicationPresenter.new(artefact)
    
    begin
      # Use a specific template if present
      render "content/page-#{params[:slug]}"
    rescue
      render "content/page"
    end
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