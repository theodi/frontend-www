# Configure asset pipeline if we're in CI, so build fails if asset pipeline isn't configured correctly
if ENV['JENKINS']
  Www::Application.configure do
    config.assets.compile = false
    config.assets.digest = true
  end
end