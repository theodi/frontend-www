require "rails_helper"

describe "external redirection", type: :request do
  test_cases = {
    "/about/space"                  => "/space", #standard
    "/people/james-smith"           => "/team/james-smith", #wildcards
    "/start-up/foo"                 => "/start-ups/foo", # wildcards
    "/guide/foo"                    => "/guides/foo", # wildcards
    "/case-study/foo"               => "/case-studies/foo-case-study",
    "/consultation-response/foo"    => "/consultation-responses/foo",
    "/media-release/foo"            => "/media-releases/foo",
    "/sites/default/files/360s/foo.jpg" => "/360s/foo.jpg",
    "/blog/training-odi-it's-date"  => "/blog/training-odi-it-s-date", # strange char regexes
    "/news/feed"                    => "/news.atom", # feeds
    "/sites/default/files/test.jpg" => "http://4a8c0405bbd8695bba65-04d82222e939dc67ec2f359e102c9add.r65.cf3.rackcdn.com/sites/default/files/test.jpg", # assets
    "/members"                      => "http://directory.theodi.org/members" # external links
  }

  test_cases.each do |from, to|
    
    it "redirects from #{from} to #{to}" do
      get from
      expect(response).to redirect_to(to)
    end
    
  end

end