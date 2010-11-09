require 'spec_helper'

#
# Integration tests - tests designed for the whole application
#

describe "LayoutLinks" do

  # Tests to make sure the right page (ie. view) is rendered in each case
  # using have_selector to check for the correct title
  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end
  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end
  it "should have a Home page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end
  it "should have a Home page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end
  it "should have a Signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
  end
  
  # Tests to make sure the links on the layout go to the correct page
  # using have_selector to check for the correct title
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Help"
    response.should have_selector('title', :content => "Help")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Home"
    response.should have_selector('title', :content => "Home")
    click_link "Sign up now!"
    response.should have_selector('title', :content => "Sign up")
  end

end
