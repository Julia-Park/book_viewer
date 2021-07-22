require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

get "/" do
  @title = 'The Adventures of Sherlock Holmes'
  @table_of_contents = []
  File.foreach("data/toc.txt") { |title| @table_of_contents << title.chomp }

  erb :home
end

get "/chapters/1" do
  @title = "Chapter 1"
  @table_of_contents = []
  File.foreach("data/toc.txt") { |title| @table_of_contents << title.chomp }
  @chapter = File.readlines("data/chp1.txt").join("<br>")
  
  erb :chapter
end
