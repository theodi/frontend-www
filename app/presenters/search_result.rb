class SearchResult

  PATH_LOOKUP = {
    "consultation-response" => "consultation_responses_article_path",
    "blog" => "blog_article_path",
    "start-up" => "start_ups_article_path",
    "team" => "team_article_path",
    "writers" => "team_article_path",
    "artists" => "team_article_path",
    "board" => "team_article_path",
    "guide" => "guides_article_path",
    "lunchtime-lecture" => "lunchtime_lectures_article_path",
    "meetup" => "meetups_article_path",
    "research-afternoon" => "research_afternoons_article_path",
    "open-data-challenge-series" => "challenge_series_article_path",
    "roundtable" => "roundtables_article_path",
    "workshop" => "workshops_article_path",
    "networking-events" => "networking_events_article_path",
    "panel-discussions" => "panel_discussions_article_path",
    "news" => "news_article_path",
    "creative_work" => "culture_article_path",
    "job" => "jobs_article_path",
    "case_study" => "case_studies_article_path",
    "node" => "nodes_article_path",
    "course" => "courses_article_path"
  }

  def initialize(result)
    @result = result.stringify_keys!
  end

  def self.result_accessor(*keys)
    keys.each do |key|
      define_method key do
        @result[key.to_s]
      end
    end
  end

  def self.details_accessor(*keys)
    keys.each do |key|
      define_method key do
        @result['details'][key.to_s]
      end
    end
  end

  result_accessor :title, :es_score
  details_accessor :slug, :format, :description, :date, :course

  def path
    if format == "course_instance"
      Rails.application.routes.url_helpers.send("course_instance_path", course, date)
    else
      Rails.application.routes.url_helpers.send(path_name(format), slug)
    end
  end

  private

    def path_name(format)
      PATH_LOOKUP[format] || "page_path"
    end

end
