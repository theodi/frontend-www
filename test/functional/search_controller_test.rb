require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  test "should show search results" do
    stub_request(:get, "http://contentapi.dev/search.json?q=space&role=odi&page=1").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.25.0'}).
      to_return(:status => 200, :body => load_fixture('search.json'), :headers => {})

    get :perform, q: "space"
    assert_response :ok

    doc = Nokogiri::HTML response.body

    assert_match doc.search('.article-full').inner_html, /great technical team here!/
    assert_match doc.search('.article-full .article-meta').inner_text, /1 result found/
    assert_equal doc.search('.article-full .results-list li').count, 1
  end

  test "should show next page on first page" do
    stub_request(:get, "http://contentapi.dev/search.json?q=space&role=odi&page=1").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.25.0'}).
      to_return(:status => 200, :body => load_fixture('multi-page-search.json'), :headers => {})

    get :perform, q: "space"
    assert_response :ok

    doc = Nokogiri::HTML response.body

    assert_equal 1, doc.search('li.next a').count
  end

  test "should show next and previous pages on middle pages" do
    stub_request(:get, "http://contentapi.dev/search.json?q=space&role=odi&page=3").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.25.0'}).
      to_return(:status => 200, :body => load_fixture('middle-page-search.json'), :headers => {})

    get :perform, q: "space", page: 3
    assert_response :ok

    doc = Nokogiri::HTML response.body

    assert_equal 1, doc.search('li.previous a').count
    assert_equal 1, doc.search('li.next a').count
  end

  test "should not show previous page on last page" do
    stub_request(:get, "http://contentapi.dev/search.json?q=space&role=odi&page=8").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.25.0'}).
      to_return(:status => 200, :body => load_fixture('last-page-search.json'), :headers => {})

    get :perform, q: "space", page: 8
    assert_response :ok

    doc = Nokogiri::HTML response.body

    assert_equal 0, doc.search('li.next a').count
  end

end
