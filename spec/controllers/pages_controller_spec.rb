require 'spec_helper'

# Pages controller tests
# by default RSpec just tests actions inside a controller test
# if we want it also to render the views, we have to tell it explicitly
describe PagesController do
  render_views

  # executes a block of code before each test case
  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do

    describe "when not signed in" do

      before(:each) do
        get :home
      end

      it "should be successful" do
        response.should be_success
      end

      # check for an HTML element (the "selector") with the given content
      # this test requires the "render_views" line above
      it "should have the right title" do
        response.should have_selector("title",
                                      :content => "#{@base_title} | Home")
      end
    end

    describe "when signed in" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end

      it "should have the right follower/following counts" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
    end

  end

  # 1st line: describing a GET operation for the 'home' action (just a description that can be anything)
  # 2nd line: when visiting the page, it should be successful (again what goes inside the quote marks is irrelevant)
  # 3rd line: actually submits a GET request (it acts like a browser and hits a page)
  # 4th line: the response of our application should indicate success (ie. return a status code of 200)
  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the correct title" do
      get 'contact'
      response.should have_selector("title",
                        :content => @base_title + " | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the correct title" do
      get 'about'
      response.should have_selector("title",
                        :content => @base_title + " | About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the correct title" do
      get 'help'
      response.should have_selector("title",
                        :content => @base_title + " | Help")
    end
  end

end
