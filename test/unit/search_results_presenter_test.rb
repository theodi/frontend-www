require 'test_helper'

class SearchResultsPresenterTest < ActiveSupport::TestCase

  def setup
    @search_response = {
      "total"         => 2,
      "start_index"   => 0,
      "page_size"     => 10,
      "current_page"  => 1,
      "pages"         => 1,
      "results"       => [
        {
          "id"      => "http://contentapi.dev/space.json",
          "web_url" => "http://www.dev/space",
          "title"   => "Our Space",
          "details" => {
            "description" => "Here is some text",
             "slug"       => "space",
             "tag_ids"    => ["page", "odi"],
             "format"     => "page",
             "created_at" => "2012-12-03T19:59:19+00:00"
            }
        }
      ]
    }
  end

  test "should return the correct stuff" do
    results = SearchResultsPresenter.new(@search_response)

    assert_equal 2, results.result_count
    assert_equal 1, results.current_page
    assert_equal 1, results.pages
    assert_equal false, results.has_previous_page?
    assert_equal false, results.has_next_page?
  end

  test "should return next and previous page stuff correctly" do
    results = SearchResultsPresenter.new(@search_response.merge({"pages" => 5, "current_page" => 2}))

    assert_equal true, results.has_previous_page?
    assert_equal true, results.has_next_page?
  end

  test "should return false for next page when on last page" do
    results = SearchResultsPresenter.new(@search_response.merge({"pages" => 5, "current_page" => 5}))

    assert_equal false, results.has_next_page?
  end

end
