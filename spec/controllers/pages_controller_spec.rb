require 'spec_helper'

# Pages controller tests
# by default RSpec just tests actions inside a controller test
# if we want it also to render the views, we have to tell it explicitly
describe PagesController do
  render_views

  # 1st line: describing a GET operation for the 'home' action (just a description that can be anything)
  # 2nd line: when visiting the page, it should be successful (again what goes inside the quote marks is irrelevant)
  # 3rd line: actually submits a GET request (it acts like a browser and hits a page)
  # 4th line: the response of our application should indicate success (ie. return a status code of 200)
  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    # check for an HTML element (the "selector") with the given content
    # this test requires the "render_views" line above
    it "should have the correct title" do
      get 'home'
      response.should have_selector("title",
                        :content => "Ruby on Rails Tutorial Sample App | Home")
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the correct title" do
      get 'contact'
      response.should have_selector("title",
                        :content => "Ruby on Rails Tutorial Sample App | Contact")
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
                        :content => "Ruby on Rails Tutorial Sample App | About")
    end
  end

end
