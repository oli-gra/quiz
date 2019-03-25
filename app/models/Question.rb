class Question < ActiveRecord::Base

    def self.get_questions
        url = 'https://opentdb.com/api.php?amount=50&category=9&difficulty=medium&type=multiple'
        data = JSON.parse(response)

        data["results"].each do |t|
          Question.find_or_create_by(
            category: t["category"], 
            type: t["type"],
            difficulty: t["difficulty"], 
            question: t["question"],
            correct_answer: t["correct_answer"], 
            incorrect_answers: t["correct_answer"], 
            
        end
      end
end
    
