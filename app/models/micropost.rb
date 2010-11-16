# == Schema Information
# Schema version: 20101116091125
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base

  # tell Rails which attributes are accessible (ie. can be modified by users)
  # also important for preventing a mass assignment vulnerability
  attr_accessible :content

  # define model relations
  belongs_to :user

  # define validation (using validates method)
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true

  # use Rails facility 'default_scope' with an :order parameter to define ordering
  default_scope :order => 'microposts.created_at DESC'
  
end
