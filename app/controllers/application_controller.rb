class ApplicationController < ActionController::Base
  # API only applications don't include this module or a session middleware
  # by default, and so don't require CSRF protection to be configured.
  # But, here we are still using ActionController::Base instead of ActionController::API
  # so, we are skipping CSRF Token verification for API calls
  # Source: plata.news/blog/cant verify CSRF token problem
  protect_from_forgery unless: -> { request.format.json? }
  respond_to :json
end
