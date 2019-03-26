class User < ActiveRecord::Base
  has_many :leaderboards
  has_many :questions, through: :leaderboards

end
