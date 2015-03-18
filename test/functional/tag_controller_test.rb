require 'test_helper'

class TagControllerTest < ActionController::TestCase

  test "should show entries for a given tag" do
    stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&keyword=data-driven&role=odi&tag=").
      to_return(:status => 200, :body => load_fixture('tag-data-driven.json'), :headers => {})

    get :index, tag: "data-driven"
    assert_response :ok

    doc = Nokogiri::HTML response.body

    assert_match doc.search('.content').inner_html, /Established from its inception/
    assert_match doc.search('.result-count').inner_text, /1 result found/
    assert_equal doc.search('.tag-results ul li').count, 1
  end

  test "should do what without tags?" do
    skip
    # TODO: still need to handle what happens when no
    # tag is returned.
  end
end
