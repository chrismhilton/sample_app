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
      get :new # 'new'
      response.should be_success
    end

    it "should have the correct title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end

    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end

    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end

    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end

    it "should have a password confirmation field"do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end


  end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      # verify that a failed create action doesn't create a user in the database
      # RSpec change method to return the change in the number of users in the database
      # Ruby construct 'lambda' allows check that test doesn't change the User count
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      # check that a failed signup attempt just re-renders the new user page
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

    end

    describe "success" do

      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      # test for a flash message on successful user signup
      # using 'equals-tilde' =~ operator for comparing strings to regular expressions
      # along with '/i' so the comparison is case-insensitive
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end

    end

  end

end
