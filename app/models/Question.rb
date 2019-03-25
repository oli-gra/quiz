class Question < ActiveRecord::Base
  has_many :leaderboards
  has_many :users, through: :leaderboards

end
