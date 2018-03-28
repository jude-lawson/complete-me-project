require 'sinatra'
require_relative '../lib/complete_me'

get '/' do
  erb :index
end

post '/' do
  cm = CompleteMe.new
  dictionary = File.read("/usr/share/dict/words")
  cm.populate(dictionary)
  suggestions = cm.suggest(params[:word])
  erb :results, :locals => {:suggestions => suggestions}
end