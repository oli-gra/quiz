require_relative './config/environment'
require 'sinatra/activerecord/rake'

desc 'Start our app console'
task :console do
    Pry.start
end

desc 'Start our app'
task :run do
  session = Ui.new
  session.welcome
  session.handle_question
end
