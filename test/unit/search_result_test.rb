require 'test_helper'

class SearchResultTest < ActiveSupport::TestCase

  def setup
    @result = {
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
  end

  test "should present a result correctly" do
    result = SearchResult.new(@result)

    assert_equal result.title, "Our Space"
    assert_equal result.description, "Here is some text"
    assert_equal result.path, "/space"
  end

  test "should generate correct paths" do
    {
      "consultation-response" => "consultation-responses",
      "blog" => "blog",
      "start-up" => "start-ups",
      "team" => "team",
      "writers" => "team",
      "artists" => "team",
      "board" => "team",
      "guide" => "guides",
      "event:lunchtime-lecture" => "lunchtime-lectures",
      "event:meetup" => "meetups",
      "event:research-afternoon" => "research-afternoons",
      "event:open-data-challenge-series" => "challenge-series",
      "event:roundtable" => "roundtables",
      "event:workshop" => "workshops",
      "event:networking-events" => "networking-events",
      "event:panel-discussions" => "panel-discussions",
      "news" => "news",
      "creative_work" => "culture",
      "job" => "jobs",
      "case_study" => "case-studies",
      "node" => "nodes",
      "course" => "courses"
    }.each do |k,v|
      details = {
        "description" => "Here is some text",
         "slug"       => "space",
         "tag_ids"    => ["page", "odi"],
         "format"     => k,
         "created_at" => "2012-12-03T19:59:19+00:00"
      }
      result = SearchResult.new(@result.merge({"details" => details}))

      assert_equal result.path, "/#{v}/space"
    end
  end

end
