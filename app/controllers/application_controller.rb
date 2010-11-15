class ApplicationController < ActionController::Base
  protect_from_forgery

  # include the session helper so that its functions are accessible in controllers
  # (helpers are automatically included in Rails views)
  include SessionsHelper
end
