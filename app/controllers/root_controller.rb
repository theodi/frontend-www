require 'gds_api/helpers'
require 'gds_api/content_api'
require 'artefact_retriever'

class RecordNotFound < StandardError
end

class RootController < ApplicationController
  
  def action_missing(name, *args, &block)
    if name.to_s =~ /^(.*)_list_module$/
      list_module(params)
    elsif name.to_s =~ /^(.*)_list$/
      list(params)
    elsif name.to_s =~ /^(.*)_module$/
      _module(params)
    elsif name.to_s =~ /^(.*)_article$/
      article(params)
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

  def course_instance
    @publication = fetch_article(params[:slug], params[:edition])
    @course = fetch_article(course_slug, params[:edition])
    @title = @course.title + " - " + DateTime.parse(@publication.date).strftime("%A %d %B %Y")
    respond_to do |format|
      format.html do
        render "content/course_instance"
      end
      format.json do
        render :json => @publication.to_json
      end
    end
  end
  
  def courses_article
    @publication = fetch_article(params[:slug], params[:edition])
    @instances = content_api.sorted_by('course_instance', 'date').results.delete_if { 
                  |course| course.details.course != params[:slug] || DateTime.parse(course.details.date) < Time.now }
    @instances.sort_by! { |instance| instance.details.date }
    
    respond_to do |format|
      format.html do
        render "content/course"
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
  
  def team_list_module
    @section = 'team'
    render "list_module/people", :layout => 'minimal'
  end

  protected
  
  def list(params)
    @section = params[:section].parameterize
    @artefacts = content_api.sorted_by(params[:section], "date").results
    @title = params[:section].humanize.capitalize
    begin
      # Use a specific template if present
      render "list/#{params[:section]}"
    rescue
      render "list/list"
    end
  end

  def list_module(params)
    @section = params[:section].parameterize
    @artefacts = content_api.sorted_by(params[:section], "date").results
    @title = params[:section].humanize.capitalize
    begin
      # Use a specific template if present
      render "list_module/#{params[:section]}", :layout => "minimal"
    rescue
      render "list_module/list_module", :layout => "minimal"
    end
  end

  def _module(params)
    artefact = ArtefactRetriever.new(content_api, Rails.logger, statsd).
                  fetch_artefact(params[:slug], params[:edition], nil, nil)

    # If the content type or tag doesn't match the slug, return 404
    if artefact['format'] != params[:section].singularize && 
        artefact['tags'].map { |t| t['content_with_tag']['slug'] == params[:section].singularize }.all? { |v| v === false }
      raise ActionController::RoutingError.new('Not Found') 
    end

    @section = params[:section].parameterize
    @publication = PublicationPresenter.new(artefact)
    begin
      # Use a specific template if present
      render "module/#{params[:section]}", :layout => "minimal"
    rescue
      render "module/module", :layout => "minimal"
    end
  end
  
  def article(params)
    @publication = fetch_article(params[:slug], params[:edition])
    
    respond_to do |format|
      format.html do
        render "content/#{@publication.format}"
      end
      format.json do
        render :json => @publication.to_json
      end
    end
  end
  
  def fetch_article(slug, edition)
    artefact = ArtefactRetriever.new(content_api, Rails.logger, statsd).
                  fetch_artefact(slug, edition, nil, nil)

    # If the content type or tag doesn't match the slug, return 404
    if artefact['format'] != params[:section].singularize && 
        artefact['tags'].map { |t| t['content_with_tag']['slug'] == params[:section].singularize }.all? { |v| v === false }
      raise ActionController::RoutingError.new('Not Found') 
    end

    PublicationPresenter.new(artefact)
  end

end
