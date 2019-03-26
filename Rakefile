require_relative './config/environment'
require 'sinatra/activerecord/rake'

desc 'Start our app console'
task :console do
    Pry.start
end

desc 'Start our app'
task :run do
  Ui.welcome
  Ui.display_question
end
