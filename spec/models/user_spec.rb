require 'spec_helper'

describe User do
  
  # run the code inside the block before each test
  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
      }
  end

  # sanity check test to verify that the User model is basically working
  # create! ("create bang") works like create except that it raises an
  # ActiveRecord::RecordInvalid exception if the creation fails
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  # pending spec - a way to write a description of the application’s behaviour
  # without worrying yet about the implementation
  # useful as placeholders for tests we need to write in the future
  #it "this is how to define a pending spec"

  # test for the presence of the name attribute
  # using hash merge method to make name attribute invalid
  # RSpec adopts the useful convention of allowing us to test any boolean method
  # by dropping the question mark and prepending be_ (equivalent is "no_name_user.valid?.should_not == true")
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  # test for the presence of the email attribute
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  # test length of name attribute (using string multiplication)
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  # test emails are valid (using common forms)
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  # test emails are invalid
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  # test email uniqueness (case insensitive)
  # by creating a user and then trying to make another one with the same email
  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    uppercase_email = @attr[:email].upcase
    User.create!(@attr.merge( { :email => uppercase_email } ))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  # password validation tests
  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end

  end

  # password encryption tests
  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    # Ruby method respond_to? accepts a symbol
    # and returns true if the object responds to the given method or attribute
    # in this case using RSpec’s respond_to helper method
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    # verify that encrypted_password.blank? is not true
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end

      describe "authenticate method" do

        it "should return nil on email/password mismatch" do
          wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
          wrong_password_user.should be_nil
        end

        it "should return nil for an email address with no user" do
          nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
          nonexistent_user.should be_nil
        end

        it "should return the user on email/password match" do
          matching_user = User.authenticate(@attr[:email], @attr[:password])
          matching_user.should == @user
        end

      end

    end

  end

  describe "admin attributes" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end

  end
  
  describe "micropost associations" do

    before(:each) do
      @user = User.create(@attr)
      # create microposts so that oldest created first to allow for test of ordering
      # Factory Girl allows setting of created_at manually which Active Record won’t allow
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end

    it "should destroy associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end

    end

    describe "status feed" do

      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should include the user's microposts" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end

      it "should not include a different user's microposts" do
        mp3 = Factory(:micropost,
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp3).should be_false
      end

    end

  end

end
