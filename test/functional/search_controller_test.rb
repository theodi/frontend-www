require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  test "should show search results" do
    stub_request(:get, "http://contentapi.dev/search.json?q=fuck&role=odi").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.25.0'}).
      to_return(:status => 200, :body => load_fixture('search.json'), :headers => {})

    get :perform, q: "fuck"
    assert_response :ok

    doc = Nokogiri::HTML response.body

    assert_match doc.search('.article-full').inner_html, /great technical team here!/
    assert_match doc.search('.article-full .article-meta').inner_text, /1 result found/
    assert_equal doc.search('.article-full .results-list li').count, 1
  end

end
