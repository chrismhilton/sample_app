class PagesController < ApplicationController
  
  def home
    # create instance variable and assign page title
    # in Rails their role is primarily to link actions and views
    # any instance variable defined in the home action is automatically available in the "home.html.erb" view
    # instance variables are nil if not defined
    @title = "Home"
    if signed_in?
      # instance variable used by shared micropost partial displayed in home page
      @micropost = Micropost.new
      # instance variable used by shared feed partial displayed in home page
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end

end
