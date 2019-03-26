class Ui

  def initialize
    puts `clear`
    @prompt = TTY::Prompt.new
    @progress = TTY::ProgressBar.new("Moare [:bar]\n", output: $stdout, total: 10)
    @questions = []
  end

  def header
    @prompt.say 'Quiz head-to-head and claim victory over your friends'
  end

  def welcome
    header
    name = @prompt.ask 'What is your name ?'
    User.find_or_create_by(name: name)
    @user = User.find_by(name: name)
    @prompt.say "Good luck #{@user.name}!"
  end

  def self.show_leaderboard
    # TODO set display top 5 results + time
  end

  def show_progress
    @progress.advance
  end

  def show_question
    @random = Question.all[rand(Question.all.size)]
    if @questions.include?(@random) == false
      choices = [
        @random.answer,
        @random.wrong_1,
        @random.wrong_2,
        @random.wrong_3].shuffle
      show_progress
      @prompt.select(@random.question, choices)
    elsif @progress.current < 9
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

  def goodbye
    @prompt.say 'Bye!'
  end

  def new_game?
    if @prompt.yes?('Another game?')
      session = Ui.new
      header
      session.handle_question
    else
      goodbye
    end
  end

  def show_stats
    session = Leaderboard.where(user_id: @user.id).order(updated_at: :desc).limit(@questions.count)
    seconds = session.first.updated_at - session.last.updated_at
    right = session.select{|q|q.result == true}.count
    @prompt.say "Ace! #{right}/#{@questions.count} right in #{seconds.round(0)} seconds"
    new_game?
  end

  def handle_question
    until @progress.complete?
      if show_question == @random.answer
        @prompt.ok 'Right!'
        addto_leaderboard(true)
      else
        @prompt.error ":-( right answer is #{@random.answer}"
        addto_leaderboard(false)
      end
      @questions << @random
    end
    show_stats
  end

end
