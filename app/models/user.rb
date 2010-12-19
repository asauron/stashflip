class User < ActiveRecord::Base
  #attr_accessible :username, :email, :password
  
  has_one :info
  has_many :maps
  has_many :favorite_maps
  
  has_many :friendships
  
  has_many :friends,
  			:through => :friendships, 			
  			:conditions => "status = 'accepted'",
  			:order => :username

  has_many :friends_pending,
  			:through => :friendships,
  			:source => :friend,  			
  			:conditions => "status = 'pending'",
  			:order => :time_created
  			  			
  has_many :friends_requested,
  			:through => :friendships,
  			:source => :friend,
  			:conditions => "status = 'requested'",
  			:order => :time_created
  			
  acts_as_authentic
  
  ajaxful_rater

end
