require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "page_title should work when only the page title is present" do
    @view_flow = ActionView::OutputFlow.new
    content_for(:page_title) { "Here is the main title" }
    assert_equal "Here is the main title | Open Data Institute", page_title
  end

  test "page_title should work when only the section title is present" do
    @view_flow = ActionView::OutputFlow.new
    content_for(:title) { "<a href='/foo'>Section title</a>".html_safe }
    assert_equal "Section title | Open Data Institute", page_title
  end

  test "page_title should work when the section title and page title are present" do
    @view_flow = ActionView::OutputFlow.new
    content_for(:page_title) { "Here is the main title" }
    content_for(:title) { "<a href='/foo'>Section title</a>".html_safe }
    assert_equal "Here is the main title | Section title | Open Data Institute", page_title
  end

end
