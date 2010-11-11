class UsersController < ApplicationController
  
  def new
    @user = User.new
    @title = "Sign up"
  end

  def show
    # using the standard Rails 'params' object to retrieve the user id
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    # 'params' contains a hash of hashes
    @user = User.new(params[:user])
    if @user.save
      # assign message to flash variable/hash for display to user
      flash[:success] = "Welcome to the Sample App!"
      # redirect to the show page
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

end
