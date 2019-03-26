class Ui

  def self.welcome
    puts `clear`
    @prompt = TTY::Prompt.new(symbols: {pointer: '>'})
    @prompt.say 'Quiz head-to-head and claim victory over your friends'
    name = @prompt.ask 'What is your name ?'
    if User.find_or_create_by(name: name)
      puts "Welcome back #{name}" else
      puts 'Okay, you are in'
    end
  end

  def self.display_question
    random = Question.all[rand(Question.all.size)]
    # TODO check an array that question hasn't already been asked user this session
    @prompt.select(random.question) do |menu|
      # TODO add answers to an array and randomly pop them out
      menu.choice random.answer, 1
      menu.choice random.wrong_1, 2
      menu.choice random.wrong_2, 3
      menu.choice random.wrong_3, 4
    end
  end

end
