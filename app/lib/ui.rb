class Ui

  def initialize
    puts `clear`
    @prompt = TTY::Prompt.new
    @progress = TTY::ProgressBar.new("Questions [:bar]", total: 10)
    @questions = []
  end

  def welcome
    @prompt.say 'Quiz head-to-head and claim victory over your friends'
    name = @prompt.ask 'What is your name ?'
    User.find_or_create_by(name: name)
    @user = User.find_by(name: name)
    @prompt.say "Good luck #{@user.name}!"
  end

  def self.show_leaderboard
    # TODO set display top 5 results + time
  end

  def show_progress
    puts `clear`
    @prompt.say @progress.advance
  end

  def show_question
    @random = Question.all[rand(Question.all.size)]
    if @questions.include?(@random) == false
      choices = [
        @random.answer,
        @random.wrong_1,
        @random.wrong_2,
        @random.wrong_3].shuffle
      # TODO check an array that question hasn't already been asked user this session
      show_progress
      @prompt.select(@random.question, choices)
    else
      show_question
    end
  end

  def addto_leaderboard(result)
    @board = Leaderboard.new
    @board.question_id = @random.id
    @board.user_id = @user.id
    @board.result = result
    @board.save
  end

  def handle_question
    if show_question == @random.answer
      @prompt.ok 'Right!'
      addto_leaderboard(true)
    else
      @prompt.error 'Uh, oh.'
      addto_leaderboard(false)
    end
    @questions << @random
    show_question
  end

end
