# == Schema Information
# Schema version: 20101110094725
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base

  # schema info above created using "annotate" command

  # tell Rails which attributes are accessible (ie. can be modified by users)
  # also important for preventing a mass assignment vulnerability
  attr_accessible :name, :email

  # email format regular expression (regex)
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # define validation (using validates method)
  # uniqueness enforces uniqueness at the model level ie. when creating a new user object
  # so also need to enforce at database level to cater for two objects in memory with the same email
  # by creating a database index and requiring the index be unique
  # can also catch the ActiveRecord::StatementInvalid exception that gets raised (not done in tutorial)
  validates :name,  :presence   => true,
                    :length     => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

end
