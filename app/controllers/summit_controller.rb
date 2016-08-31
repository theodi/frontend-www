class SummitController < RootController

  def index
    @year = params[:year].to_i
    @section = "summit"
    params[:slug] = summit_pages[@year]['summit']
    @speakers = content_api.sorted_by("summit-speaker-#{@year}", 'curated').results
    @sessions = content_api.sorted_by("event:summit-session-#{@year}", 'curated').results
    article(params, @section)
  end

  def speaker_list
    @year = params[:year]
    @section = params[:section].parameterize
    @artefacts = content_api.sorted_by(@section.dasherize, 'curated').results
    @title = "Summit #{@year} Speakers"
    respond_to do |format|
      format.html do
        render "list/summit-speakers-listing"
      end
      format.json do
        redirect_to "#{api_domain}/with_tag.json?tag=summit-speaker"
      end
    end
  end

  def speaker_article
    @year = params[:year]
    @publication = fetch_article(params[:slug], params[:edition], 'person')

    respond_to do |format|
      format.html do
        render "content/summit_speaker"
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
    end
  end

  def session_article
    @year = params[:year]
    @publication = fetch_article(params[:slug], params[:edition], 'event')

    respond_to do |format|
      format.html do
        render "content/summit_session"
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
    end
  end

  def session_list
    @year = params[:year]
    @section = params[:section].parameterize
    @artefacts = content_api.sorted_by('event:summit-session-2016', 'curated').results
    @title = "Summit #{@year} Sessions"
    respond_to do |format|
      format.html do
        render "list/summit-sessions-listing"
      end
      format.json do
        redirect_to "#{api_domain}/with_tag.json?tag=summit-sessions-2016"
      end
    end
  end

  def training_day_page
    @year = params[:year].to_i
    @section = "summit_training_day"
    params[:slug] = summit_pages[@year]['training']
    @sessions = get_sessions
    article(params, @section)
  end

  def training_day_article
    @year = params[:year]
    @publication = fetch_article(params[:slug], params[:edition], 'event')
    @trainer = get_trainer

    respond_to do |format|
      format.html do
        render "content/training_day_session"
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
    end
  end

  private

    def summit_pages
      YAML.load_file(File.join Rails.root, 'config' , 'summit_pages.yml')
    end

    def get_sessions
      results = content_api.sorted_by("event:summit-training-day-session-#{@year}", 'curated').results
      sessions = {}

      ['explorer','strategist','practitioner','pioneer'].each do |type|
        sessions[type] = results.select { |r| r.tag_ids.include?("stream-#{type}") }
                                .sort_by { |r| DateTime.parse(r.details.start_date) }
      end

      sessions
    end

    def get_trainer
      person = @publication.artefact.related.select { |r| r.format == 'person' }.try(:first)
      if person.present?
        fetch_article(person.slug, nil, 'person')
      else
        nil
      end
    end

end
