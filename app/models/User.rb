class User < ActiveRecord::Base
  has_many :leaderboards
  has_many :questions, through: :leaderboards
 
  def print_result
    puts "Your Pass ratio #{result}%"
  end

  def result
    all_results = Leaderboard.where(user_id: self.id)
    pass = Leaderboard.where(user_id: self.id, result: "t")
    pass_ratio = (pass.count).to_f/(all_results.count).to_f * 100
  end

  def self.results
    hash = {}
    self.all.each{|u| hash[u.name] = u.result }
    return hash.sort_by {|k,v| v}.reverse
  end
end
