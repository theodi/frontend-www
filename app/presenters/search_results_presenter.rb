class SearchResultsPresenter

  def initialize(search_response)
    @search_response = search_response
  end

  def result_count
    search_response["total"]
  end

  def current_page
    search_response["current_page"]
  end

  def pages
    search_response["pages"]
  end

  def results
    search_response["results"].map do |result|
      SearchResult.new(result)
    end
  end

  def has_previous_page?
    current_page != 1
  end

  def has_next_page?
    current_page != pages
  end

  private

  attr_reader :search_response

end
