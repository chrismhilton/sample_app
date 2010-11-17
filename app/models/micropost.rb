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

  # return microposts from the users being followed by the given user
  # for use by user model feed method
  # using a scope - a Rails method for restricting database selects based on certain conditions
  # scopes are better than plain class methods as they can be chained with other method
  # eg. User.from_users_followed_by.paginate(:page => 1)
  # scope requires an user argument defined using a lambda (anonymous method)
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private

    # return an SQL condition for users followed by the given user
    # including the user's own id as well
    # Generates the following SQL with a subselect:
    # SELECT * FROM microposts
    # WHERE user_id IN (SELECT followed_id FROM relationships WHERE follower_id = 1)
    # OR user_id = 1
    def self.followed_by(user)
      followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id",
            { :user_id => user })
    end
  
end
