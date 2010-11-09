class PagesController < ApplicationController
  
  def home
    # create instance variable and assign page title
    # in Rails their role is primarily to link actions and views
    # any instance variable defined in the home action is automatically available in the "home.html.erb" view
    @title = "Home"
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

end