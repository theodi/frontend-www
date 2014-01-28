require 'gds_api/helpers'
require 'gds_api/content_api'

class RootController < ApplicationController
  slimmer_template :www
  
  before_filter(:except => [:index, :section, /^(.*)_list_module$/]) { alternate_formats [:json] }
  before_filter(:only => [:news_list, :jobs_list, :events_list, :nodes_article, :team_article]) { alternate_formats [:atom, :json] }
  
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
    @section = content_api.section("index")
    render "section/section"
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
    people = []
    @teams.map do |team,hash|
      members = content_api.sorted_by(team.to_s, "curated").results.delete_if { |member| people.include?(member.slug) }
      people += members.map { |member| member.slug }
      hash[:people] = members
    end
    @title = "Team"
    respond_to do |format|
      format.html do
        render "list/people"
      end
      format.json do
        redirect_to "#{api_domain}/with_tag.json?tag=team"
      end
    end  
  end

  def case_studies_list
    @section = params[:section].parameterize
    @artefacts = content_api.sorted_by('case_study', 'curated').results
    @title = "Case Studies"
    respond_to do |format|
      format.html do
        render "list/list"
      end
      format.json do
        redirect_to "#{api_domain}/with_tag.json?tag=case_study"
      end
    end
  end

  def culture_list
    @publication = fetch_article('culture', params[:edition], 'article')
    respond_to do |format|
      format.html do
        render "content/culture_page"
      end
      format.json do
        redirect_to "#{api_domain}/culture.json"
      end
    end
  end

  def culture_collection
    @section = 'culture'
    @artefacts = content_api.sorted_by('creative_work', 'curated').results
    respond_to do |format|
      format.html do
        render "list/culture"
      end
      format.json do
        redirect_to "#{api_domain}/with_tag.json?tag=creative_work"
      end
    end
  end

  def events_article
    if params[:event_type]
      @section = "lunchtime-lectures" if params[:event_type].to_sym == :lunchtime_lectures
      article(@section, params)    
    else
      event = ArtefactRetriever.new(content_api, Rails.logger, statsd).fetch_artefact(params[:slug], params[:edition], nil, nil)
      raise ActionController::RoutingError.new('Not Found') if event.nil?
    	redirect_to event_path(event)
    end
  end

  def events_list
    @section = 'events'
    @artefacts = collect_events(['event', 'course_instance'], :upcoming)
    @title = "What's happening?"
    respond_to do |format|
      format.html do
        render "list/events"
      end
      format.json do
        redirect_to "#{api_domain}/with_tag.json?tag=events"
      end
      format.atom do
        render "list/feed", :layout => false
      end
    end  
  end
  
  def lunchtime_lectures
    @section = 'lunchtime-lectures'
    @upcoming = collect_events(['lunchtime-lecture'], :upcoming)
    @previous = collect_events(['lunchtime-lecture'], :previous)
    @title = "Lunchtime Lectures"
    @publication = fetch_article("lunchtime-lectures", nil, "article")
    respond_to do |format|
      format.html do
        render "list/lunchtime-lectures"
      end
      format.json do
        redirect_to "#{api_domain}/with_tag.json?tag=events"
      end
      format.atom do
        render "list/feed", :layout => false
      end
    end  
  end
  
  def previous_events
    @section = 'events'
    @artefacts = collect_events(['event', 'course_instance'], :previous)
    @title = "Previous Events"
    respond_to do |format|
      format.html do
        render "list/list"
      end
      format.json do
        redirect_to "#{api_domain}/with_tag.json?tag=events"
      end
      format.atom do
        render "list/feed", :layout => false
      end
    end
  end

  def nodes_list
    @section = params[:section].parameterize
    @publication = fetch_article('about-nodes', params[:edition], "article")
    begin
      @artefacts = content_api.sorted_by('node', 'curated').results
      levels = {"country" => 0, "city" => 1, "comms" => 2}
      @artefacts.sort! do |a,b|
        comp = (levels[a.details.level] <=> levels[b.details.level])
        comp.zero? ? (a.title <=> b.title) : comp
      end
    rescue (GdsApi::HTTPNotFound)
    end
    @title = "Nodes"
    respond_to do |format|
      format.html do
        render "list/nodes"
      end
      format.json do
        redirect_to "#{api_domain}/with_tag.json?tag=node"
      end
    end
  end

  def nodes_article
    @section = 'news'
    @news_artefacts = news_artefacts(node: params[:slug])
    @publication = fetch_article(params[:slug], params[:edition], params[:section])
    
    respond_to do |format|
      format.html do
        render "content/node"
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
      format.atom do
        @artefacts = @news_artefacts
        @title = "ODI Node News for #{@publication.title}"
        render "list/feed"
      end
    end
  end
  

  def start_ups_article
    @section = 'news'
    @news_artefacts = news_artefacts(organization_name: params[:slug])
    @publication = fetch_article(params[:slug], params[:edition], params[:section])
    
    respond_to do |format|
      format.html do
        render "content/organization"
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
      format.atom do
        @artefacts = @news_artefacts
        @title = "ODI Start-Up News for #{@publication.title}"
        render "list/feed"
      end
    end
  end

  def team_article
    @section = 'news'
    @news_artefacts = news_artefacts(author: params[:slug])
    @publication = fetch_article(params[:slug], params[:edition], params[:section])
    
    respond_to do |format|
      format.html do
        render "content/person"
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
      format.atom do
        @artefacts = @news_artefacts
        @title = "News for #{@publication.title}"
        render "list/feed"
      end
    end
  end

  def start_ups_list
    @publication = fetch_article('start-ups', params[:edition], "article") rescue nil
    list(params)
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
    respond_to do |format|
      format.html do
        begin
          # Use a specific template if present
          render "content/page-#{params[:slug]}.json"
        rescue
          render "content/page"
        end
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
    end
  end

  def newsletters
    respond_to do |format|
      format.html do
        render "content/newsletters"
      end
    end
  end

  def course_instance
    # Parse date to check validity
    date = Date.parse(params[:date]) rescue nil
    raise RecordNotFound if date.nil?
    # Get instance
    instance = content_api.course_instance(date.strftime("%Y-%m-%d"), params[:slug], params[:edition])
    
    @publication = PublicationPresenter.new(instance)
    @course = fetch_article(@publication.course, nil, "courses", false)
    @trainers = @publication.details['trainers'] ? @publication.details['trainers'].map { |t| fetch_article(t, nil, "people", false) unless t == "" }.reject{|p| p.nil?} : []
    @title = @course.title + " - " + DateTime.parse(@publication.date).strftime("%A %d %B %Y")
    
    content_for :page_title, @title
    
    respond_to do |format|
      format.html do
        render "content/course_instance"
      end
      format.json do
        redirect_to "#{api_domain}/course-instance.json?date=#{params[:date]}&course=#{params[:slug]}"
      end
    end
  end
  
  def courses_article
    @publication = fetch_article(params[:slug], params[:edition], "courses")
    @instances = content_api.sorted_by('course_instance', 'date').results.delete_if { 
                  |course| course.details.course != params[:slug] || DateTime.parse(course.details.date) < Time.now }
    @instances.sort_by! { |instance| instance.details.date }
    
    respond_to do |format|
      format.html do
        render "content/course"
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
    end
  end
  
  def case_studies_article
    @publication = fetch_article(params[:slug], params[:edition], "case_study")
    
    respond_to do |format|
      format.html do
        render "content/case_study"
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
    end
  end
  
  def consultation_responses_article
    @publication = fetch_article(params[:slug], params[:edition], "consultation-response")
    
    respond_to do |format|
      format.html do
        render "content/consultation_response"
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
    end
  end

  def culture_article
    @publication = fetch_article(params[:slug], params[:edition], "creative_work")
    @artist = fetch_article(@publication.artist['slug'], params[:edition], 'person')
    respond_to do |format|
      format.html do
        render "content/culture"
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
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
        slimmer_template "embedded"
        render "badges/#{@publication.format}"
      end
      format.js do
        slimmer_template nil
        render "badges/#{@publication.format}"
      end
    end
  end
  
  def team_list_module
    @section = 'team'
    slimmer_template "minimal"
    render "list_module/people", layout: 'minimal'
  end
  
  def courses_list_module
    @artefact = content_api.upcoming("course_instance", "date")
    @course = fetch_article(@artefact.details.course, nil, "courses")
    @title = "Courses"
    slimmer_template "minimal"
    render "list_module/courses", layout: 'minimal'
  end
  
  def events_list_module
    @section = "events"
    @artefact = content_api.upcoming("event", "start_date")
    @title = "Events"
    slimmer_template "minimal"
    render "list_module/list_module", layout: 'minimal'
  end

  def culture_list_module
    @section = 'culture'
    @artefact = content_api.latest('type', 'creative_work')
    @title = "Culture"
    slimmer_template "minimal"
    render "list_module/list_module", layout: 'minimal'
  end

  def news_list
    options = {}
    if params[:format] == "atom"
      options["whole_body"] = true
    end
    @artefacts = news_artefacts(options)
    @hero_image = 'news_hero.jpg'
    list(params)
  end

  protected
  
  def list(params)
    @section = params[:section].parameterize
    options = {}
    if params[:format] == "atom"
      options["whole_body"] = true
    end
    @artefacts ||= content_api.with_tag(params[:section].singularize, options).results
    @title = params[:section].gsub('-', ' ').humanize.capitalize
    respond_to do |format|
      format.html do
        begin
          # Use a specific template if present
          render "list/#{params[:section]}"
        rescue
          render "list/list"
        end
      end
      format.json do
        redirect_to "#{api_domain}/with_tag.json?tag=#{params[:section].singularize}"
      end
      format.atom do
        slimmer_template nil
        render "list/feed"
      end
    end
  end

  def news_artefacts(options = {})
    artefacts = content_api.with_tag('news', options).results + content_api.with_tag('blog', options).results
    artefacts.sort_by!{|x| x.created_at}.reverse!
    artefacts
  end

  def list_module(params)
    @section = params[:section].parameterize
    @artefact = content_api.latest("tag", params[:section])
    @title = params[:section].humanize.capitalize
    slimmer_template "minimal"
    begin
      # Use a specific template if present
      render "list_module/#{params[:section]}", layout: 'minimal'
    rescue
      render "list_module/list_module", layout: 'minimal'
    end
  end

  def _module(params)
    @publication = fetch_article(params[:slug], nil, params[:section])
    @section = params[:section].parameterize
    slimmer_template "minimal"
    begin
      # Use a specific template if present
      render "module/#{params[:section]}", layout: 'minimal'
    rescue
      render "module/module", layout: 'minimal'
    end
  end
  
  def article(section = nil, params)
    section ||= params[:section]
    @publication = fetch_article(params[:slug], params[:edition], params[:section])
    
    respond_to do |format|
      format.html do
        begin
          render "content/#{section}"
        rescue ActionView::MissingTemplate
          render "content/#{@publication.format}"
        end
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
    end
  end
  
  def fetch_article(slug, edition, section, set_title = true)
    artefact = ArtefactRetriever.new(content_api, Rails.logger, statsd).
                  fetch_artefact(slug, edition, nil, nil)
    
    if set_title
      content_for :page_title, artefact.title
    end

    # If the content type or tag doesn't match the slug, return 404
    if artefact['format'] != section.singularize && 
        artefact['tags'].map { |t| t['content_with_tag']['slug'] == params[:section].singularize }.all? { |v| v === false }
      raise ActionController::RoutingError.new('Not Found') 
    end

    PublicationPresenter.new(artefact)
  end
  
  def collect_events(tags, type)
    artefacts = collect_artefacts(tags)
    if type == :previous
      artefacts.reject!{|x| Date.parse(x.details.start_date || x.details.date) > Date.today}
      artefacts.sort_by!{|x| Date.parse(x.details.start_date || x.details.date)}.reverse!
    elsif type == :upcoming
      artefacts.reject!{|x| Date.parse(x.details.start_date || x.details.date) < Date.today}
      artefacts.sort_by!{|x| Date.parse(x.details.start_date || x.details.date)}
    end
    return artefacts
  end
  
  def collect_artefacts(tags)
    artefacts = []
    tags.each do |tag|
      artefacts += content_api.with_tag(tag).results
    end
    return artefacts
  end
  
  def api_domain
    Plek.current.find("contentapi")
  end

end
