JuviaRails.configure do |config|
  
  config.server_url    = ENV['JUVIA_BASE_URL']
  config.site_key      = ENV['QUIRKAFLEEG_FRONTEND_JUVIA_SITE_KEY']
  
  config.comment_order = 'earliest-first'
  config.include_css = false

end