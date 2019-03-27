class Ui

  def initialize
    puts `clear`
    @prompt = TTY::Prompt.new
    @progress = TTY::ProgressBar.new("Keep it up [:bar]\n", output: $stdout, total: 10)
    @questions = []
  end

  def header
    @prompt.say "
    ██████╗  ██╗   ██╗ ██╗ ███████╗
   ██╔═══██╗ ██║   ██║ ██║ ╚══███╔╝    head-to-head
   ██║   ██║ ██║   ██║ ██║   ███╔╝     and claim
   ██║▄▄ ██║ ██║   ██║ ██║  ███╔╝      victory over
   ╚██████╔╝ ╚██████╔╝ ██║ ███████╗    your friends
    ╚══▀▀═╝   ╚═════╝  ╚═╝ ╚══════╝
    "
  end

  def welcome
    header
    name = @prompt.ask 'What is your name ?'
    @@user = User.find_or_create_by(name: name)
    @prompt.say "Good luck #{@@user.name.upcase}!"
  end

  def self.show_leaderboard
    # TODO set display top 5 results + time
  end

  def show_progress
    @progress.advance
  end

  def difficulty
    if @session_ratio >85
      @random = Question.where(difficulty: 'hard')[rand(40)]
    elsif @session_ratio >60
      @random = Question.where(difficulty: 'medium')[rand(40)]
    else
      @random = Question.where(difficulty: 'easy')[rand(40)]
    end
  end

  def show_question
    if difficulty && @questions.include?(@random) == false
      choices = [
        @random.answer,
        @random.wrong_1,
        @random.wrong_2,
        @random.wrong_3].shuffle
      puts "\n"
      show_progress
      @prompt.select(@random.question, choices)
    elsif @progress.current < 9 && @questions.count < 40
      show_question
    else
      @prompt.say 'We are exhausted. Why not take a break.'
      new_game?
    end
  end

  def addto_leaderboard(result)
    @board = Leaderboard.new
    @board.question_id = @random.id
    @board.user_id = @@user.id
    @board.result = result
    @board.save
  end

  def goodbye
    @prompt.error 'Bye!'
  end

  def new_game?
      choices = ['new game', 'leaderboard', 'clear results', 'delete profile', 'exit']
      case @prompt.select('What do you want to do next!?', choices)
      when 'new game'
        session = Ui.new
        session.header
        session.handle_question
      when 'clear results'
        Leaderboard.where(user:@@user).destroy_all
        new_game?
      when 'delete profile'
        User.delete(@@user.id)
        session = Ui.new
        session.welcome
        session.handle_question
      when 'exit'
        goodbye
      end
  end

  def show_stats
    puts "\n"
    @prompt.say "#{@@user.result[:right]}/10 in #{@@user.result[:seconds]}s. Your hit rate is #{@@user.result[:ratio]}% overall."
    new_game?
  end

  def handle_question
    @session_ratio = @@user.result[:ratio]
    until @progress.complete?
      if show_question == @random.answer
        @prompt.ok 'Right!'
        addto_leaderboard(true)
      else
        @prompt.error ":-( try #{@random.answer}"
        addto_leaderboard(false)
      end
      @questions << @random
    end
    show_stats
  end

end
