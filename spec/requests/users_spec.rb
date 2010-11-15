require 'spec_helper'

#
# Integration tests
#
# provide ability to test the structure of the signup form and that submissions actually work
# ties together all the different parts of Rails, including models, views, controllers, routing, and helpers;
# it provides an end-to-end verification that our signup machinery is working
#

describe "Users" do

  describe "signup" do

    describe "failure" do

      # test failed submission
      # verify that the code inside the lambda block doesn't change the value of User.count
      # you can use the CSS id of the text box instead of the label, so 'fill_in :user_name'
      # also works (this is especially nice for forms that don’t use labels)
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          # CSS-inspired shorthand for 'div id="error_explanation"'
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end

    end

    describe "success" do

      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success", :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end

    end
    
  end

  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in :email,    :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end

    end

    # click_link "Sign out" :- not only simulates a browser clicking the signout link
    # but also raises an error if no such link exists; thereby testing the URL, the named route,
    # the link text, and the changing of the layout links, all in one line
    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        visit signin_path
        fill_in :email,    :with => user.email
        fill_in :password, :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end

    end

  end

end

