# User relationships controller class
# able to access SessionsHelper methods as the module is included in the Application controller (app/controllers/application_controller.rb)
class RelationshipsController < ApplicationController

  # before filters to specify the methods to call before certain actions
  before_filter :authenticate

  # create and destroy action cater for Ajax request using JavaScript Embedded Ruby files
  # to update the user show (profile) page upon being followed or unfollowed.
  # Inside the files, Rails automatically provides the Prototype JavaScript helpers
  # to manipulate the page using the Document Object Model (DOM).
  # They use Prototype dollar-sign syntax to access a DOM element based on its unique CSS id:
  # $("follow_form")
  # They use update method to update the HTML inside the relevant element:
  # $("follow_form").update(...)
  # They use 'escape_javascript' to escape out the result when inserting HTML

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    # respond to a normal HTTP request with a redirect
    # or respond to an Ajax request with JavaScript
    # NB: only one of the lines gets executed
    # in the case of an Ajax request, Rails automatically calls a JavaScript Embedded Ruby (.js.erb) file
    # with the same name as the action eg. 'create.js.erb' used to update the current page
    # including a mix of JavaScript and Embedded Ruby to perform actions on the current page
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    # respond to a normal HTTP request with a redirect
    # or respond to an Ajax request with JavaScript
    # NB: only one of the lines gets executed
    # in the case of an Ajax request, Rails automatically calls a JavaScript Embedded Ruby (.js.erb) file
    # with the same name as the action eg. 'destroy.js.erb'
    # including a mix of JavaScript and Embedded Ruby to perform actions on the current page
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
