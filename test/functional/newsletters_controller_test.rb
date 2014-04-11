require 'test_helper'

class NewslettersControllerTest < ActionController::TestCase
  
  test "should display the form" do
    get :index
    assert_response :ok

    page = Nokogiri::HTML(response.body)
    assert_equal "/newsletters", page.css('form')[0][:action]
    assert_equal "post", page.css('form')[0][:method]
    assert_equal 6, page.css('.form-group').count
  end

  test "should display the correct newsletters" do
    get :index
    assert_response :ok

    page = Nokogiri::HTML(response.body)
    assert_equal "a1c4b47c3a", page.css('.checkbox input')[0][:value]
    assert_equal "ODI Newsletter", page.css('.checkbox label')[0].text.strip
    assert_equal "News from the ODI", page.css('.checkbox p.help-block')[0].text.strip

    assert_equal "55b8ea4d35", page.css('.checkbox input')[1][:value]
    assert_equal "ODI Robot", page.css('.checkbox label')[1].text.strip
    assert_equal "Interesting links shared by our team", page.css('.checkbox p.help-block')[1].text.strip
  end

  test "should subscribe to a list sucessfully" do
    VCR.use_cassette('should_subscribe_to_a_list_sucessfully') do
      email = "tech@theodi.org"
      first_name = "Testy"
      last_name = "McTest"
      format = "HTML"
      newsletters = ["a1c4b47c3a"]

      post :create, {
                      email: email,
                      first_name: first_name,
                      last_name: last_name,
                      format: format,
                      newsletters: newsletters
                    }

      assert_response :ok

      assert_match /You have been sucessfully subscribed to your selected list\(s\)/, response.body
    end
  end

  test "should subscribe to multiple lists sucessfully" do
    VCR.use_cassette('should_subscribe_to_multiple_lists_sucessfully') do
      email = "tech@theodi.org"
      first_name = "Testy"
      last_name = "McTest"
      format = "HTML"
      newsletters = ["a1c4b47c3a", "55b8ea4d35"]

      post :create, {
                      email: email,
                      first_name: first_name,
                      last_name: last_name,
                      format: format,
                      newsletters: newsletters
                    }

      assert_response :ok

      assert_match /You have been sucessfully subscribed to your selected list\(s\)/, response.body
    end
  end

  test "should show an error for missing fields" do
    VCR.use_cassette('should_show_an_error_for_missing_fields') do
      first_name = "Testy"
      last_name = "McTest"
      format = "HTML"
      newsletters = ["a1c4b47c3a", "55b8ea4d35"]

      post :create, {
                      first_name: first_name,
                      last_name: last_name,
                      format: format,
                      newsletters: newsletters
                    }

      assert_response :ok

      assert_match /There were a few problems with your input, please check and try again/, response.body
      assert_match /Email can&#x27;t be blank/, response.body
    end
  end

  test "should show an error if a user is already signed up" do
    VCR.use_cassette('should_show_an_error_if_a_user_is_already_signed_up') do
      email = "stuart.harrison@theodi.org"
      first_name = "Testy"
      last_name = "McTest"
      format = "HTML"
      newsletters = ["a1c4b47c3a", "55b8ea4d35"]

      post :create, {
                      email: email,
                      first_name: first_name,
                      last_name: last_name,
                      format: format,
                      newsletters: newsletters
                    }

      assert_response :ok
      assert_match /There were a few problems with your input, please check and try again/, response.body
      assert_match /stuart.harrison@theodi.org is already subscribed to list This is a list/, response.body
      assert_match /stuart.harrison@theodi.org is already subscribed to list This is another list/, response.body

    end
  end

end
