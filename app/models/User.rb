class User < ActiveRecord::Base
  has_many :leaderboards
  has_many :questions, through: :leaderboards

  def print_result
    puts "Your Pass ratio #{result}%"
  end

  def result
    all_results = Leaderboard.where(user_id: self.id)
    all_right = Leaderboard.where(user_id: self.id, result: "t")
    if all_results.count > 1
      ratio = (all_right.count)/(all_results.count).to_f * 100
      session = all_results.order(updated_at: :desc).limit(10)
      seconds = session.first.updated_at - session.last.updated_at
      session_right = session.select{|q|q.result == true}.count
      result = {right:session_right, ratio:ratio.round(0), seconds:seconds.round(0)}
    else
      result = {right:0, ratio:0, seconds:0}
    end
  end

  def self.results
    hash = {}
    self.all.each{|u| hash[u.name] = u.result }
    return hash.sort_by {|k,v| v}.reverse
  end

end
