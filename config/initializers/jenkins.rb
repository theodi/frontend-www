# Configure asset pipeline if we're in CI, so build fails if asset pipeline isn't configured correctly
if ENV['JENKINS']
  Www::Application.configure do
    config.assets.compile = false
    config.assets.digest = true
    config.assets.precompile += %w( layout.js badge.css ie9.css ie8.css ie7.css ie6.css respond.min.js html5shiv.js
                                    bootstrap/bootstrap-collapse.js modernizr.custom.js masonry.js )
  end
end