require 'htmlentities'
coder = HTMLEntities.new

User.destroy_all
Question.destroy_all
Leaderboard.destroy_all
Question.get_questions("easy")
Question.get_questions("medium")
Question.get_questions("hard")

Question.all.each {|q| q.update(answer: coder.decode(q.answer)) }
Question.all.each {|q| q.update(wrong_1: coder.decode(q.wrong_1))}
Question.all.each {|q| q.update(wrong_2: coder.decode(q.wrong_2))}
Question.all.each {|q| q.update(wrong_3: coder.decode(q.wrong_3))}
Question.all.each {|q| q.update(question: coder.decode(q.question))}
