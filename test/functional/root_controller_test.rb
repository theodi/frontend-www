require 'test_helper'

class RootControllerTest < ActionController::TestCase

  test "should get index" do
    stub_request(:get, "http://contentapi.dev/section.json?id=index").
      to_return(:status => 200, :body => load_fixture('homepage.json'), :headers => {})

    get :index
    assert_response :ok

    page = Nokogiri::HTML(response.body)

    assert_equal "http://www.example.com", page.css('.hero a')[0][:href]
    assert_equal "http://bd7a65e2cb448908f934-86a50c88e47af9e1fb58ce0672b5a500.r32.cf3.rackcdn.com/uploads/assets/e7/86/52e78659d0d4624a8c000063/about_hero.jpg", page.css('.hero img')[0][:src]
    assert_match /The Open Data Institute/, page.css('.hero .hero-label')[0].text

    modules = page.css('.home-module')

    assert_equal 3, modules.count

    assert_equal "Show me the future of Open Data and... Food", modules[0].css('img')[0][:alt]
    assert_equal "http://bd7a65e2cb448908f934-86a50c88e47af9e1fb58ce0672b5a500.r32.cf3.rackcdn.com/uploads/assets/e6/63/52e663b81f986a2ef000006e/20140113_odifutures_food.jpg", modules[0].css('img')[0][:src]
    assert_equal "http://theodi.org/research-afternoons/show-me-the-future-of-food-and-open-data", modules[0].css('a')[0][:href]

    assert_equal "news/module", modules[1].css('iframe')[0][:src]

    assert_match /Introducing Open Data Partnership for Development/, modules[2].css('.module-heading')[0].text
    assert_match /GLOBAL PROJECTS/, modules[2].css('.module-subheading')[0].text
    assert_match /module-colour-2/, modules[2].css('div')[0][:class]
    assert_equal "http://theodi.org/odp4d", modules[2].css('a')[0][:href]
  end

  test "should get about page" do
    stub_request(:get, "http://contentapi.dev/section.json?id=about").
      to_return(:status => 200, :body => load_fixture('homepage.json'), :headers => {})

    get :section, :section => "about"
    assert_response :ok
  end

  test "should get page" do
    stub_request(:get, "http://contentapi.dev/data-as-culture-2014.json").
      to_return(:status => 200, :body => load_fixture('data-as-culture-2014.json'), :headers => {})

    get :page, :slug => 'data-as-culture-2014'
    assert_response :ok
  end

  test "should show related content against a page" do
    stub_request(:get, "http://contentapi.dev/data-as-culture-2014.json").
      to_return(:status => 200, :body => load_fixture('data-as-culture-2014.json'), :headers => {})

    get :page, :slug => 'data-as-culture-2014'
    assert_response :ok

    assert_match /<div class="article-main">/, response.body.squish

    assert_match /<a href="http:\/\/theodi.org\/culture\/about"> <h1 class="module-heading">Data as Culture 2014<\/h1> <\/a>/, response.body.squish
    assert_match /<a href="http:\/\/theodi.org\/culture\/collection"> <h1 class="module-heading">Data as Culture 2012\/13 the collection<\/h1> <\/a>/, response.body.squish
    assert_match /<a href="http:\/\/theodi.org\/blog\/cornerstone-open-data-postcode-address-file"> <h1 class="module-heading">A Cornerstone for Open Data: The Postcode Address File<\/h1> <\/a>/, response.body.squish
  end

  test "should not show a sidebar for content without related content" do
    stub_request(:get, "http://contentapi.dev/data-as-culture-2014.json").
      to_return(:status => 200, :body => load_fixture('no-related.json'), :headers => {})

    get :page, :slug => 'data-as-culture-2014'
    assert_response :ok

    assert_match /<div class="article-full">/, response.body.squish

    assert_no_match /<aside class="article-sidebar">/, response.body.squish
  end

  test "courses should have an atom feed" do
      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&sort=date&tag=course_instance").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
        to_return(:status => 200, :body => load_fixture('course-instances.json'), :headers => {})
      stub_request(:get, "http://contentapi.dev/open-data-marketers.json").
          to_return(:status => 200, :body => load_fixture('open-data-marketers.json'), :headers => {})
      get :courses_article, :slug => 'open-data-marketers', :section=> 'courses'

      assert_response :ok
      page = Nokogiri::HTML(response.body)

      assert_equal "/courses/open-data-marketers.atom", page.css('head link')[0][:href]
    end

    test "courses atom feed should return the correct stuff" do
      Timecop.freeze(Time.parse("2013-12-22T13:00:00+00:00"))
      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&sort=date&tag=course_instance").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
        to_return(:status => 200, :body => load_fixture('course-instances.json'), :headers => {})
      stub_request(:get, "http://contentapi.dev/introduction-open-data-journalists-finding-stories-data.json").
          to_return(:status => 200, :body => load_fixture('introduction-open-data-journalists-finding-stories-data.json'), :headers => {})
      get :courses_article, :slug => 'introduction-open-data-journalists-finding-stories-data', :section=> 'courses', :format => 'atom'

      assert_response :ok

      page = Nokogiri::XML(response.body)

      assert_equal 1, page.css("entry").count

      Timecop.return
    end

    test "courses list atom feed should return the correct stuff" do
      Timecop.freeze(Time.parse("2014-02-14T13:00:00+00:00"))

      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&sort=date&tag=course_instance").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
        to_return(:status => 200, :body => load_fixture('course-instances-short.json'), :headers => {})

      stub_request(:get, "http://contentapi.dev/open-data-practice.json").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
        to_return(:status => 200, :body => load_fixture('open-data-practice.json'), :headers => {})

      get :courses_list, :slug => 'introduction-open-data-journalists-finding-stories-data', :section=> 'courses', :format => 'atom'

      assert_response :ok

      page = Nokogiri::XML(response.body)

      assert_equal 2, page.css("entry").count

      Timecop.return
    end

    test "courses should include instances in a sidebar" do
      Timecop.freeze(Time.parse("2013-12-22T13:00:00+00:00"))
      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&sort=date&tag=course_instance").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
        to_return(:status => 200, :body => load_fixture('course-instances.json'), :headers => {})
      stub_request(:get, "http://contentapi.dev/introduction-open-data-journalists-finding-stories-data.json").
          to_return(:status => 200, :body => load_fixture('introduction-open-data-journalists-finding-stories-data.json'), :headers => {})

      get :courses_article, :slug => 'introduction-open-data-journalists-finding-stories-data', :section=> 'courses'

      assert_response :ok

      page = Nokogiri::HTML(response.body)

      assert_equal 1, page.css('.course-sidebar .module').count
      assert_equal "Thursday 27 February 2014", page.css('.course-sidebar .module h3').text
      assert_equal "Over the hills and far away", page.css('.course-sidebar .module p')[0].text

      Timecop.return
    end

    test "course instances should load correctly" do
      stub_request(:get, "http://contentapi.dev/course-instance.json?course=open-data-marketers&date=2014-01-22").
        to_return(:status => 200, :body => load_fixture('open-data-marketers-2014-01-22.json'), :headers => {})
      stub_request(:get, "http://contentapi.dev/open-data-marketers.json").
          to_return(:status => 200, :body => load_fixture('open-data-marketers.json'), :headers => {})
      stub_request(:get, "http://contentapi.dev/kathryn-corrick.json").
        to_return(:status => 200, :body => load_fixture('kathryn-corrick.json'), :headers => {})
      get :course_instance, :slug => 'open-data-marketers', :date => '2014-01-22'
      assert_response :ok
    end

    test "course instances should 404 if date is incorrect" do
      get :course_instance, :slug => 'course-name', :date => 'spang'
      assert_response :not_found
    end

    test "course instances without trainers should render OK" do
      stub_request(:get, "http://contentapi.dev/course-instance.json?course=open-data-practice&date=2013-04-08").
        to_return(:status => 200, :body => load_fixture('open-data-practice-2013-04-08.json'), :headers => {})
      stub_request(:get, "http://contentapi.dev/open-data-practice.json").
          to_return(:status => 200, :body => load_fixture('open-data-practice.json'), :headers => {})
      get :course_instance, :slug => 'open-data-practice', :date => '2013-04-08'
      assert_response :ok
    end

    test "past events should return correct title" do
      stub_request(:get, "http://contentapi.dev/friday-lunchtime-lecture-how-politicians-lie-with-data.json").
        to_return(:status => 200, :body => load_fixture('show-me-the-future-of-food-and-open-data.json'), :headers => {})
      get :events_article, :slug => 'friday-lunchtime-lecture-how-politicians-lie-with-data',
          :section=>"events", :event_type=>:event

      assert_match /<h1> <a href="\/events\/previous">Previous Events<\/a> <\/h1>/, response.body.squish
    end

    test "lunchtime lectures should have correct title" do
      stub_request(:get, "http://contentapi.dev/friday-lunchtime-lecture-how-politicians-lie-with-data.json").
        to_return(:status => 200, :body => load_fixture('friday-lunchtime-lecture-how-politicians-lie-with-data.json'), :headers => {})
      get :events_article, :slug => 'friday-lunchtime-lecture-how-politicians-lie-with-data',
          :section=>"events", :event_type=>:lunchtime_lectures

      assert_match /<h1> <a href="\/lunchtime-lectures">Lunchtime Lectures<\/a> <\/h1>/, response.body.squish
    end

    test "lunchtime lectures should show related lectures" do
      stub_request(:get, "http://contentapi.dev/friday-lunchtime-lecture-why-anonymity-fails.json").
        to_return(:status => 200, :body => load_fixture('friday-lunchtime-lecture-why-anonymity-fails.json'), :headers => {})
      get :events_article, :slug => 'friday-lunchtime-lecture-why-anonymity-fails',
          :section=>"events", :event_type=>:lunchtime_lectures

      page = Nokogiri::HTML(response.body)

      assert_equal 3, page.css('.module').count
      assert_equal "Friday lunchtime lecture: FACELESS - what if all our lives were recorded?", page.css('.module h1').first.text
      assert_equal "http://www.dev/lunchtime-lectures/friday-lunchtime-lecture-faceless-what-if-all-our-lives-were-recorded", page.css('.module a').first[:href]
    end

    test "past events should return not show the booking link" do
      stub_request(:get, "http://contentapi.dev/friday-lunchtime-lecture-how-politicians-lie-with-data.json").
        to_return(:status => 200, :body => load_fixture('friday-lunchtime-lecture-how-politicians-lie-with-data.json'), :headers => {})
      get :events_article, :slug => 'friday-lunchtime-lecture-how-politicians-lie-with-data',
          :section=>"events", :event_type=>:lunchtime_lectures

      assert_not_match /More information and to book your place/, response.body.squish
    end

    test "Handles nil code response from content API with a proper 500 page" do
      GdsApi::HTTPErrorResponse.any_instance.expects(:code).at_least_once.returns(nil)
      GdsApi::ContentApi.any_instance.expects(:artefact).raises(GdsApi::HTTPErrorResponse, '')
      get :page, :slug => 'broken'
      assert_response 500
    end

    test "lunchtime lectures should have an atom feed" do
      stub_request(:get, "http://contentapi.dev/lunchtime-lectures.json").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
        to_return(:status => 200, :body => load_fixture('lunchtime-lectures-intro.json'), :headers => {})

      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=lunchtime-lecture").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
        to_return(:status => 200, :body => load_fixture('lunchtime-lectures.json'), :headers => {})

      get :lunchtime_lectures

      assert_response :ok
      page = Nokogiri::HTML(response.body)

      assert_equal "/lunchtime-lectures.atom", page.css('head link')[0][:href]
    end

    test "lunchtime lectures atom feed should return the correct stuff" do
      Timecop.freeze(Time.parse("2013-12-22T13:00:00+00:00"))

      stub_request(:get, "http://contentapi.dev/lunchtime-lectures.json").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
        to_return(:status => 200, :body => load_fixture('lunchtime-lectures-intro.json'), :headers => {})

      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=lunchtime-lecture").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
        to_return(:status => 200, :body => load_fixture('lunchtime-lectures.json'), :headers => {})

      get :lunchtime_lectures, :format => 'atom'

      assert_response :ok

      page = Nokogiri::XML(response.body)

      assert_equal 5, page.css("entry").count

      Timecop.return
    end

    test "previous lunchtime lectures atom feed should return the correct stuff" do
      Timecop.freeze(Time.parse("2013-12-22T13:00:00+00:00"))

      stub_request(:get, "http://contentapi.dev/lunchtime-lectures.json").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
        to_return(:status => 200, :body => load_fixture('lunchtime-lectures-intro.json'), :headers => {})

      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=lunchtime-lecture").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
        to_return(:status => 200, :body => load_fixture('lunchtime-lectures.json'), :headers => {})

      get :lunchtime_lectures, :format => 'atom', :type => 'previous'

      assert_response :ok

      page = Nokogiri::XML(response.body)

      assert_equal 7, page.css("entry").count

      Timecop.return
    end

    test "upcoming lectures should show the livestream iframe if livestream is set to true" do
      Timecop.freeze(Time.parse("2013-11-14T13:00:00+00:00"))
      stub_request(:get, "http://contentapi.dev/friday-lunchtime-lecture-how-politicians-lie-with-data.json").
        to_return(:status => 200, :body => load_fixture('lecture-with-livestream.json'), :headers => {})
      get :events_article, :slug => 'friday-lunchtime-lecture-how-politicians-lie-with-data',
          :section=>"events", :event_type => :lunchtime_lectures

      assert_match /Live stream/, response.body
      Timecop.return
    end

    test "upcoming lectures should not show the livestream iframe if livestream is set to false" do
      Timecop.freeze(Time.parse("2013-11-14T13:00:00+00:00"))
      stub_request(:get, "http://contentapi.dev/friday-lunchtime-lecture-how-politicians-lie-with-data.json").
        to_return(:status => 200, :body => load_fixture('lecture-no-livestream.json'), :headers => {})
      get :events_article, :slug => 'friday-lunchtime-lecture-how-politicians-lie-with-data',
          :section=>"events", :event_type => :lunchtime_lectures

      assert_not_match /Live stream/, response.body
      Timecop.return
    end

    test "Atom feeds should return full text feed" do
      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=news&whole_body=true").
        to_return(:status => 200, :body => load_fixture('full-text-news.json'), :headers => {})
      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=blog&whole_body=true").
        to_return(:status => 200, :body => '{"total":47,"start_index":1,"page_size":47,"current_page":1,"pages":1,"_response_info":{"status":"ok","links":[]},"description":"","results": []}', :headers => {})


      get :news_list, :format => 'atom', :section=>"news"

      xml = Nokogiri::XML(response.body)
      assert_equal "<p>Ahead of <a rel=\"external\" href=\"http://summit.theodi.org/\">our Summit</a> in London on 29 October, we're delighted to be announcing two new members; London-based <a rel=\"external\" href=\"http://www.ratesetter.com\">RateSetter</a>, and Seattle's <a rel=\"external\" href=\"http://www.socrata.com\">Socrata</a>. They take our membership to 45, and are testimony to the international appeal and multi-sector influence that we are forging.</p>", xml.xpath("//xmlns:entry/xmlns:content").text
    end

    test "Jobs list shows message if no jobs are listed" do
      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=job").
        to_return(:status => 200, :body => load_fixture('no-jobs.json'), :headers => {})

      get :jobs_list, :section => "jobs"

      assert_match /Sorry there are no jobs currently listed. We regularly add new jobs, so keep checking back, or subscribe to our <a href="\/jobs.atom">atom feed<\/a>/, response.body
    end

    test "should get previous events page with old events" do
      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=event").
        to_return(:status => 200, :body => load_fixture('events.json'), :headers => {})
      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=course_instance").
        to_return(:status => 200, :body => load_fixture('empty.json'), :headers => {})

      get :previous_events, :section=>"events"

      assert_match /Friday lunchtime lecture/, response.body

      html = Nokogiri::HTML(response.body)
      assert_equal nil, html.css(".hero img").first

    end
    test "should get featured events on previous events" do
      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=event").
        to_return(:status => 200, :body => load_fixture('events-with-featured.json'), :headers => {})
      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=course_instance").
        to_return(:status => 200, :body => load_fixture('empty.json'), :headers => {})

      get :previous_events, :section=>"events"

      assert_match /Featured/, response.body
      assert_match /All Events/, response.body
    end

    test "should get featured events on events page" do
      Timecop.freeze( Time.parse("2014-01-14T13:00:00+00:00") )

      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=event").
        to_return(:status => 200, :body => load_fixture('events-with-featured.json'), :headers => {})
      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=course_instance").
        to_return(:status => 200, :body => load_fixture('empty.json'), :headers => {})

      get :events_list, :section=>"events"

      assert_match /Featured/, response.body
      assert_match /All Events/, response.body

      Timecop.return
    end

    test "should get events page with forthcoming events" do
      Timecop.freeze( Time.parse("2014-01-14T13:00:00+00:00") )

      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=event").
        to_return(:status => 200, :body => load_fixture('events.json'), :headers => {})
      stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&tag=course_instance").
        to_return(:status => 200, :body => load_fixture('empty.json'), :headers => {})

      get :events_list, :section=>"events"

      assert_match /Friday lunchtime lecture/, response.body

      html = Nokogiri::HTML(response.body)
      assert_equal "http://static.dev/assets/whatshappening_hero.jpg", html.css(".hero img").first[:src]
      Timecop.return
    end

end
