require 'test_helper'

class RootControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index
    assert_response :ok
  end
  
  test "course instances should load correctly" do
    stub_request(:get, "http://contentapi.dev/course-instance.json?course=course-name&date=2100-01-01").
      to_return(:status => 200, :body => load_fixture('open-data-marketers-2014-01-22.json'), :headers => {})
    stub_request(:get, "http://contentapi.dev/open-data-marketers.json").
        to_return(:status => 200, :body => load_fixture('open-data-marketers.json'), :headers => {})
    stub_request(:get, "http://contentapi.dev/kathryn-corrick.json").
      to_return(:status => 200, :body => load_fixture('kathryn-corrick.json'), :headers => {})
    get :course_instance, :slug => 'course-name', :date => '2100-01-01'
    assert_response :ok
  end

  test "course instances should 404 if date is incorrect" do
    get :course_instance, :slug => 'course-name', :date => 'spang'
    assert_response :not_found
  end
  
end
  