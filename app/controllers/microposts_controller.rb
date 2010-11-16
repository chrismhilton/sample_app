# Microposts controller class
# able to access SessionsHelper methods as the module is included in the Application controller (app/controllers/application_controller.rb)
class MicropostsController < ApplicationController

  # before filters to specify the methods to call before certain actions
  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy

  def create
    @micropost  = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      # empty instance variable array required by shared feed partial displayed in home page
      # alternatively could set variable = current_user.feed.paginate(:page => params[:page])
      @feed_items = [] 
      render 'pages/home'
    end
  end

  def destroy
    # no need to find micropost as done in authorized_user method
    @micropost.destroy
    redirect_back_or root_path
  end

  private

    def authorized_user
      @micropost = Micropost.find(params[:id])
      redirect_to root_path unless current_user?(@micropost.user)
    end
    
end