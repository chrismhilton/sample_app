require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do

    before(:each) do
      # use User factory to create an @user variable
      # by using the symbol :user we ensure that Factory Girl
      # will guess that we want to use the User model
      # so in this case @user will simulate an instance of User
      @user = Factory(:user)
    end

    it "should be successful" do
      # "get :show" using symbol is the same as "get 'show'"
      # ":id => @user" is the same as ":id => @user.id"
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      # the assigns method takes in a symbol argument
      # and returns the value of the corresponding instance variable in the controller action
      # this line verifies that the variable retrieved from the database in the action
      # corresponds to the @user instance created by Factory Girl
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end

  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  it "should have the correct title" do
    get 'new'
    response.should have_selector("title", :content => "Sign up")
  end

end
