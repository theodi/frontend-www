require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test 'page_title should work when only the page title is present' do
    @view_flow = ActionView::OutputFlow.new
    content_for(:page_title) { 'Here is the main title' }
    assert_equal 'Here is the main title | Open Data Institute', page_title
  end

  test 'page_title should work when only the section title is present' do
    @view_flow = ActionView::OutputFlow.new
    content_for(:title) { '<a href="/foo">Section title</a>'.html_safe }
    assert_equal 'Section title | Open Data Institute', page_title
  end

  test 'page_title should work when both titles are present' do
    @view_flow = ActionView::OutputFlow.new
    content_for(:page_title) { 'Here is the main title' }
    content_for(:title) { '<a href="/foo">Section title</a>'.html_safe }
    assert_equal 'Here is the main title | Section title | Open Data Institute', page_title
  end

  test 'sessions groups sessions by time' do
    sessions = (1..4).map do |i|
      {
        'id' => "http://contentapi.dev/session-#{i}.json",
        'slug' => "session-#{i}",
        'title' => "Session #{i}",
        'format' => "event",
        'extras' => {
          'start_date' => "2016-11-01T09:00:00+00:00",
          'end_date' => "2016-11-01T10:00+00:00",
          'location' => "Place"
        }
      }
    end

    sessions << (1..3).map do |i|
      {
        'id' => "http://contentapi.dev/session-#{i}.json",
        'slug' => "session-#{i}",
        'title' => "Session #{i}",
        'format' => "event",
        'extras' => {
          'start_date' => "2016-11-01T11:00:00+00:00",
          'end_date' => "2016-11-01T12:00+00:00",
          'location' => "Place"
        }
      }
    end

    sessions << (1..2).map do |i|
      {
        'id' => "http://contentapi.dev/session-#{i}.json",
        'slug' => "session-#{i}",
        'title' => "Session #{i}",
        'format' => "event",
        'extras' => {
          'start_date' => "2016-11-01T14:00:00+00:00",
          'end_date' => "2016-11-01T16:00+00:00",
          'location' => "Place"
        }
      }
    end

    sessions << {
      'id' => "http://contentapi.dev/session.json",
      'slug' => "session",
      'title' => "Session",
      'format' => "event",
      'extras' => {
        'start_date' => "2016-11-01T16:00:00+00:00",
        'end_date' => "2016-11-01T18:00+00:00",
        'location' => "Place"
      }
    }

    sessions << {
      'id' => "http://contentapi.dev/session.json",
      'slug' => "session",
      'title' => "Session",
      'format' => "event",
      'extras' => {
        'start_date' => "2016-11-01T18:00:00+00:00",
        'end_date' => "2016-11-01T20:00+00:00",
        'location' => "Place"
      }
    }

    publication = OpenStruct.new({
      format: 'event',
      artefact: {
        'related' => sessions.flatten!
      }
    })

    sessions = event_sessions(publication)

    assert_equal sessions["09:00:00"].first, {
      title: "Session 1",
      slug: "session-1",
      start_date: "2016-11-01T09:00:00+00:00",
      end_date: "2016-11-01T10:00+00:00",
      location: "Place"
    }

    assert_equal sessions["09:00:00"].count, 4
    assert_equal sessions["11:00:00"].count, 3
    assert_equal sessions["14:00:00"].count, 2
    assert_equal sessions["16:00:00"].count, 1
    assert_equal sessions["18:00:00"].count, 1
  end

end
