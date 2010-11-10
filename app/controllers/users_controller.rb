class UsersController < ApplicationController
  
  def new
    @title = "Sign up"
  end

  def show
    # using the standard Rails params object to retrieve the user id
    @user = User.find(params[:id])
    @title = @user.name
  end

end
