class Ui

  def initialize
    puts `clear`
    @prompt = TTY::Prompt.new
    @progress = TTY::ProgressBar.new("Keep it up [:bar]\n", output: $stdout, total: 10)
    @questions = []
  end

  #
  #   Print :: $stdout stuff
  #

  def header
    @prompt.say "
 ██████╗  ██╗   ██╗ ██╗ ███████╗
██╔═══██╗ ██║   ██║ ██║ ╚══███╔╝    head-to-head
██║   ██║ ██║   ██║ ██║   ███╔╝     and claim
██║▄▄ ██║ ██║   ██║ ██║  ███╔╝      victory over
╚██████╔╝ ╚██████╔╝ ██║ ███████╗    your friends
 ╚═▀▀══╝   ╚═════╝  ╚═╝ ╚══════╝
    \n"
  end

  def welcome
    name = @prompt.ask 'What is your name ?'
    @@user = User.find_or_create_by(name: name)
    @prompt.say "Good luck #{@@user.name.upcase}!"
  end

  def goodbye
    @prompt.error 'Bye!'
  end

  def show_progress
    puts "\n"
    @progress.advance
  end

  def show_stats
    puts "\n"
    @prompt.say "#{@@user.result[:right]}/10 in #{@@user.result[:seconds]}s.Your hit rate is #{@@user.result[:ratio]}% overall."
  end

  def show_question
    if difficulty && @questions.include?(@random) == false
      show_progress
      choices = [@random.answer, @random.wrong_1, @random.wrong_2, @random.wrong_3].shuffle
      @prompt.select(@random.question, choices)
    elsif @progress.current < 9 && @questions.count < 40
      show_question
    else
      @questions = []
      show_question
    end
  end

  def show_leaderboard
  end

  #
  #   CRUD :: addto_leaderboard=create delete_user=delete clear_data=destroy
  #

  def add_leaderboard(result)
    Leaderboard.create(question_id: @random.id, user_id: @@user.id, result: result)
  end

  def delete_user
    User.delete(@@user.id)
    @prompt.error 'Profile deleted!'
  end

  def clear_data
    Leaderboard.where(user:@@user).destroy_all
    @prompt.ok 'Results cleared!'
  end

  def edit_name
    new_name = @prompt.ask "Change #{@@user.name} to:"
    User.find_by(name: @@user.name).update(name: new_name)
    @@user = User.find_by(name: new_name)
    @prompt.ok 'Name changed!'
  end

  #
  #   Game logic :: new_game=init difficulty=setter new_game?=menu handle_question=loop
  #

  def new_game(new_user)
    session = Ui.new
    session.header
    session.welcome if new_user
    session.handle_question
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

  def new_game?
      choices = ['new game', 'edit profile', 'leaderboard', 'clear results', 'delete profile']
      case @prompt.select('What do you want to do next!?', choices)
      when 'new game'
        new_game(false)
      when 'edit profile'
        edit_name
        new_game?
      when 'clear results'
        clear_data
        new_game?
      when 'delete profile'
        delete_user
        new_game(true)
      end
  end

  def handle_question
    @session_ratio = @@user.result[:ratio]
    until @progress.complete?
      if show_question == @random.answer
        @prompt.ok 'Right!'
        add_leaderboard(true)
      else
        @prompt.error "Close, try #{@random.answer}"
        add_leaderboard(false)
      end
      @questions << @random
    end
    show_stats
    new_game?
  end

end
