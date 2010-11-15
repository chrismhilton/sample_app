# == Schema Information
# Schema version: 20101115154545
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

class User < ActiveRecord::Base

  # schema info above created using "annotate" command

  # virtual attributes (attributes not corresponding columns in the database)
  attr_accessor :password

  # tell Rails which attributes are accessible (ie. can be modified by users)
  # also important for preventing a mass assignment vulnerability
  attr_accessible :name, :email, :password, :password_confirmation

  # email format regular expression (regex)
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # define validation (using validates method)
  # email uniqueness enforces uniqueness at the model level ie. when creating a new user object
  # so also need to enforce at database level to cater for two objects in memory with the same email
  # by creating a database index and requiring the index be unique
  # can also catch the ActiveRecord::StatementInvalid exception that gets raised (not done in tutorial)
  # password confirmation automatically create a virtual attribute password_confirmation
  # and length defined using a range
  validates :name,      :presence     => true,
                        :length       => { :maximum => 50 }
  validates :email,     :presence     => true,
                        :format       => { :with => email_regex },
                        :uniqueness   => { :case_sensitive => false }
  validates :password,  :presence     => true,
                        :confirmation => true,
                        :length       => { :within => 6..40 }

  # register a callback called encrypt_password by passing a symbol of that name to the before_save method
  # Active Record will automatically call the encrypt_password method before saving the record
  before_save :encrypt_password

  # Return true if the user's password matches the submitted password.
  # Public interface to the private encryption machinery
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  # a class method that will return an authenticated user based on password match, and nil otherwise
  # a class method is defined using the self keyword in the method definition;
  # is attached to a class like "User.find", rather than an instance of that class
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  # a class method that will return an authenticated user based on user id & salt from cookie, and nil otherwise
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
    # last line uses ternary operator and could also be written like this:
    # return nil  if user.nil?
    # return user if user.salt == cookie_salt
  end

  # private methods - used internally by the object and are not intended for public use
  private

    def encrypt_password
      # inside the class self refers to the object itself, which for the User model is just the user
      # without self Ruby would create a local variable called encrypted_password
      # "encrypt(password)" same as "encrypt(self.password)" as self optional (unless assigning to an attribute)
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    # encrypt string with salt
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    # make salt to use when encrypting string
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    # use cryptographic hash function SHA2 to encrypt string through the digest library
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
