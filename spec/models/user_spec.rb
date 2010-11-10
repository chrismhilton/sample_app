require 'spec_helper'

describe User do
  
  # run the code inside the block before each test
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
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
  it "should require a name (pending spec)"

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


end
