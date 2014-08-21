class SearchResult

  PATH_LOOKUP = {
    "blog" => "blog_article_path",
    "news" => "news_article_path",
    "partner-biography" => "partner_biographies_article_path",
    "partner" => "partners_article_path",
    "page" => "page_path",
    "report" => "reports_article_path",
    "networking-events" => "events_article_path"
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
  details_accessor :slug, :format, :description

  def path
    Rails.application.routes.url_helpers.send(PATH_LOOKUP[format], slug)
  end

end
