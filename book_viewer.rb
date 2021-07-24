require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

helpers do
  def in_paragraphs(string)
    string.split("\n\n").inject("") { |text, line| text + "<p>#{line}</p>" }
  end
end

before do
  @table_of_contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = 'The Adventures of Sherlock Holmes'
  @number = 0
  
  erb :home
end

get "/chapters/:number" do
  @number = params[:number].to_i
  redirect "/" unless (1..@table_of_contents.size).cover?(@number)
  
  @title = "Chapter #{@number}: #{@table_of_contents[@number - 1]}"
  @chapter = File.read("data/chp#{@number}.txt")
  
  erb :chapter
end

get "/show/:name" do
  params[:name]
end

not_found do
  redirect "/"
end