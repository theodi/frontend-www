[![Build Status](http://b.adge.me/travis/theodi/frontend-www.svg)](https://travis-ci.org/theodi/frontend-www)
[![Coverage Status](http://b.adge.me/coveralls/theodi/frontend-www.svg)](https://coveralls.io/r/theodi/frontend-www)
[![Dependency Status](http://b.adge.me/gemnasium/theodi/frontend-www.svg)](https://gemnasium.com/theodi/frontend-www)
[![Code Climate](http://b.adge.me/codeclimate/github/theodi/frontend-www.svg)](https://codeclimate.com/github/theodi/frontend-www)

# frontend-www
 
This is the front end web application that powers www.theodi.org, built atop the GDS gov.uk platform.

## Environment variables

To run the tests, you need some environment variables, which you can put in `.env`. These examples will do:

```
GOVUK_APP_DOMAIN=dev
DEV_DOMAIN=dev
JUVIA_BASE_URL=https://juvia.example.com
QUIRKAFLEEG_FRONTEND_JUVIA_SITE_KEY=abc123
QUIRKAFLEEG_FRONTEND_SESSION_SECRET=abc123
QUIRKAFLEEG_FRONTEND_CONTENTAPI_BEARER_TOKEN=abc123
MAILCHIMP_API_KEY=abc123-us6
```