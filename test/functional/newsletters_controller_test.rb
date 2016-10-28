require 'test_helper'

class NewslettersControllerTest < ActionController::TestCase

  test "should display the form" do
    get :index
    assert_response :ok

    page = Nokogiri::HTML(response.body)
    assert_equal "/newsletters", page.css('form')[0][:action]
    assert_equal "post", page.css('form')[0][:method]
    assert_equal 4, page.css('.form-group').count
  end

  test "should subscribe to a list sucessfully" do
    VCR.use_cassette('should_subscribe_to_a_list_sucessfully') do
      email = "tech@theodi.org"
      first_name = "Testy"
      last_name = "McTest"
      format = "HTML"

      post :create, {
                      id: '3089417f22',
                      email: email,
                      first_name: first_name,
                      last_name: last_name
                    }

      assert_response :ok

      assert_match /You have been successfully subscribed/, response.body
    end
  end


  test "should show an error for missing fields" do
    VCR.use_cassette('should_show_an_error_for_missing_fields') do
      first_name = "Testy"
      last_name = "McTest"

      post :create, {
                      first_name: first_name,
                      last_name: last_name,
                      id: '3089417f22'
                    }

      assert_response :ok

      assert_match /There were a few problems with your input, please check and try again/, response.body
      assert_match /Email can&#x27;t be blank/, response.body
    end
  end

  test "should show an error if a user is already signed up" do
    VCR.use_cassette('should_show_an_error_if_a_user_is_already_signed_up') do
      email = "pezholio+fefsfdsfdsfsdfdsff@gmail.com"
      first_name = "Testy"
      last_name = "McTest"
      format = "HTML"

      post :create, {
                      email: email,
                      first_name: first_name,
                      last_name: last_name,
                      id: '3089417f22'
                    }

      assert_response :ok
      assert_match /There were a few problems with your input, please check and try again/, response.body
      assert_match /pezholio\+fefsfdsfdsfsdfdsff@gmail.com is already subscribed to the list/, response.body
    end
  end

  test "should show an error if the newsetter ID does not exist" do
    VCR.use_cassette('should_show_an_error_if_the_newsletter_id_does_not_exist') do
      email = "stuart.harrison@theodi.org"
      first_name = "Testy"
      last_name = "McTest"

      post :create, {
                      email: email,
                      first_name: first_name,
                      last_name: last_name,
                      id: 'blatantlyfakeid'
                    }

      assert_response :ok
      assert_match /There were a few problems with your input, please check and try again/, response.body
      assert_match /Invalid MailChimp List ID: blatantlyfakeid/, response.body

    end
  end

  test "should show an error if the email is invalid" do
    VCR.use_cassette('should_show_an_error_if_the_email_is_invalid') do
      email = "notarealemail@example.com"
      first_name = "Testy"
      last_name = "McTest"
      format = "HTML"
      newsletters = ["a1c4b47c3a"]

      post :create, {
                      email: email,
                      first_name: first_name,
                      last_name: last_name,
                      id: '3089417f22'
                    }

      assert_response :ok
      assert_match /There were a few problems with your input, please check and try again/, response.body
      assert_match /This email address looks fake or invalid. Please enter a real email address/, response.body
    end
  end

end
