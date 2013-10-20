require 'gds_api/helpers'
require 'gds_api/content_api'
require 'artefact_retriever'

class RecordNotFound < StandardError
end

class RootController < ApplicationController
  
  def action_missing(name, *args, &block)
    if name.to_s =~ /^(.*)_list$/
      @section = params[:section].parameterize
      @artefacts = content_api.sorted_by(params[:section], "date").results
      @title = params[:section].humanize.capitalize
      begin
        # Use a specific template if present
        render "list/#{params[:section]}"
      rescue
        render "list/list"
      end
    else
      super
    end
  end

  def index
    @title = "Welcome"
  end
  
  def team_list
    @teams = {
      :board => {
        :name => "Board",
        :colour => 8
      },
      :executive => {
        :name => "Executive Team",
        :colour => 8
      },
      :commercial => {
        :name => "Commercial Team",
        :colour => 8
      },
      :technical => {
        :name => "Technical Team",
        :colour => 8
      },
      :operations => {
        :name => "Operations Team",
        :colour => 8
      },
    }
    @teams.map { |team,hash| hash[:people] = content_api.sorted_by(team.to_s, "curated").results }
    @title = "Team"
    render "list/people.html"
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
