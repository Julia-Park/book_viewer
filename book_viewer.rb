require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

get "/" do
  @title = 'The Adventures of Sherlock Holmes'
  @table_of_contents = File.readlines("data/toc.txt")
  
  erb :home
end

get "/chapters/:number" do
  number = params[:number]
  @title = "Chapter #{number}"
  @table_of_contents = File.readlines("data/toc.txt")
  @chapter = File.readlines("data/chp#{number}.txt").join("<br>")
  
  erb :chapter
end

get "/show/:name" do
  params[:name]
end
