# == Schema Information
# Schema version: 20101116152824
#
# Table name: relationships
#
#  id          :integer         not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Relationship < ActiveRecord::Base

  # Within the Relationship model
  # follower_id :- the id of the user
  # followed_id :- the id of a user being followed by the user

  # tell Rails which attributes are accessible (ie. can be modified by users)
  # also important for preventing a mass assignment vulnerability
  attr_accessible :followed_id

  # define model relations
  # Rails infers the names of the foreign keys from the corresponding symbols
  # :follower = follower_id and :followed = followed_id
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"

  # define validation (using validates method)
  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
end
