# Users controller class
# able to access SessionsHelper methods as the module is included in the Application controller (app/controllers/application_controller.rb)
class UsersController < ApplicationController

  # before filters to specify the methods to call before certain actions
  before_filter :authenticate,   :except => [:show, :new, :create]
  before_filter :correct_user,   :only => [:edit, :update]
  before_filter :admin_user,     :only => :destroy
  before_filter :signed_in_user, :only => [:new, :create]
  
  def new
    @user = User.new
    @title = "Sign up"
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    # using the standard Rails 'params' object to retrieve the user id
    @user = User.find(params[:id])
    # instance variable used for showing paged table of microposts
    # using paginate to convert array into a WillPaginate::Collection object
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def create
    # 'params' contains a hash of hashes
    @user = User.new(params[:user])
    if @user.save
      # sign in the user automatically upon sign up
      sign_in @user
      # assign message to flash variable/hash for display to user
      flash[:success] = "Welcome to the Sample App!"
      # redirect to the show page
      redirect_to @user
    else
      # clear the password fields for failed submissions
      @user.password = ""
      @user.password_confirmation = ""
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    # no need to find user as done in correct_user method
    @title = "Edit user"
  end

  def update
    # no need to find user as done in correct_user method
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    # prevent a user from deleting their own user account
    # as an alternative to using find, this statement would also work:
    # if params[:id] == current_user.id.to_s
    user = User.find(params[:id])
    if current_user?(user)
      flash[:error] = "Can not delete your own user account."
    else
      User.find(params[:id]).destroy # uses method chaining
      flash[:success] = "User deleted."
    end
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def signed_in_user
      redirect_to(root_path) unless !signed_in?
    end

  end
