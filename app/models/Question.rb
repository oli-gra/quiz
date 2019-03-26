class Question < ActiveRecord::Base
  has_many :leaderboards
  has_many :users, through: :leaderboards

  def self.get_questions
    response = RestClient.get('https://opentdb.com/api.php?amount=50&category=9&difficulty=medium&type=multiple')
    data = JSON.parse(response)

    data["results"].each do |t|
      Question.find_or_create_by(
      category: t["category"],
      difficulty: t["difficulty"],
      question: t["question"],
      answer: t["correct_answer"],
      wrong_1: t["incorrect_answers"][0],
      wrong_2: t["incorrect_answers"][1],
      wrong_3: t["incorrect_answers"][2])          
    end
  end
end
