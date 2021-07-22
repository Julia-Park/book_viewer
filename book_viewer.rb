require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

get "/" do
  @title = 'The Adventures of Sherlock Holmes'
  @table_of_contents = []
  
  File.foreach("data/toc.txt") { |title| @table_of_contents << title.chomp }

  erb :home
end
