require 'test_helper'

class TagControllerTest < ActionController::TestCase

  test "should show entries for a given tag" do
    stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&keyword=data-driven&role=odi&tag=").
      to_return(:status => 200, :body => load_fixture('tag-data-driven.json'), :headers => {})

    get :index, tag: "data-driven", format: 'html'
    assert_response :ok

    doc = Nokogiri::HTML response.body

    assert_match doc.search('.content').inner_html, /Established from its inception/
    assert_match doc.search('.result-count').inner_text, /1 result found/

    assert_equal doc.search('.tag-results ul li').count, 1
  end

  test "should return a blank list index without tag" do
    get :index, format: 'html'

    assert_response :ok

    doc = Nokogiri::HTML response.body

    assert_match doc.search('.no-result').inner_html, /We couldn't find anything/
    assert_match doc.search('.result-count').inner_text, /0 results found/
  end

  test "should return a json response with a tag" do
    stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&keyword=data-driven&role=odi&tag=").
      to_return(:status => 200, :body => load_fixture('tag-data-driven.json'), :headers => {})

    get :index, tag: "data-driven", format: 'json'

    assert_response :ok
    parsed = JSON.parse(response.body)
    assert_match parsed[0]["table"]["title"], /Data as Culture/
    assert_equal parsed.count, 1
  end

  test "should return an atom response with a tag" do
    stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&keyword=data-driven&role=odi&tag=").
      to_return(:status => 200, :body => load_fixture('tag-data-driven.json'), :headers => {})

    get :index, tag: "data-driven", format: 'atom'

    assert_response :ok

    doc = Nokogiri::XML(response.body)
    assert_equal doc.search('entry').count, 1
  end
end
