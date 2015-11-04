# The application controller supplies the root gateway for such tasks as the home page
# and user actions.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  add_flash_types :more_notice

  # The root action that delivers a static home page.
  def index
    render template: "static/home.html.erb"
  end
end
