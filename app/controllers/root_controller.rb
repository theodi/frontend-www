require 'gds_api/helpers'
require 'gds_api/content_api'
require 'artefact_retriever'

class RecordNotFound < StandardError
end

class RootController < ApplicationController
  
  def action_missing(name, *args, &block)
    if name.to_s =~ /^(.*)_list$/
      @section = params[:section].parameterize
      @artefacts = content_api.sorted_by(params[:section], "curated").results
      @title = params[:section].humanize.capitalize
      render "list/list.html"
    else
      super
    end
  end

  def index
    @title = "Welcome"
  end
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

    # If the content type or tag doesn't match the slug, return 404
    if artefact['format'] != params[:section].singularize && 
        artefact['tags'].map { |t| t['content_with_tag']['slug'] == params[:section].singularize }.all? { |v| v === false }
      raise ActionController::RoutingError.new('Not Found') 
    end

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

  def badge
    artefact = ArtefactRetriever.new(content_api, Rails.logger, statsd).
                  fetch_artefact(params[:slug], params[:edition], nil, nil)

    @publication = PublicationPresenter.new(artefact)
    raise RecordNotFound unless @publication.widget?
    respond_to do |format|
      format.html do
        render "badges/#{@publication.format}", :layout => "embedded"
      end
      format.js do
        render "badges/#{@publication.format}", :layout => nil
      end
    end
  end

end
