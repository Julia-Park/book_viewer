require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

before do
  @table_of_contents = File.readlines("data/toc.txt")
  @number = 0
end

helpers do
  def in_paragraphs(string)
    string.split("\n\n").inject("") { |text, line| text + "<p>#{line}</p>" }
  end

  def contents(chapter_number)
    File.read("data/chp#{chapter_number}.txt")
  end

  def search_chapters(query) # return hash chp#: chp path
    result = {}
    return result if query == ""
    search_regexp = Regexp.new(query, Regexp::IGNORECASE)

    (1..@table_of_contents.size).each do |chapter_num|
      if @table_of_contents[chapter_num - 1].match?(search_regexp) || contents(chapter_num).match?(search_regexp)
        result[chapter_num - 1] = "/chapters/#{chapter_num}"
      end
    end

    result
  end
end


get "/" do
  @title = 'The Adventures of Sherlock Holmes'
  
  erb :home
end

get "/chapters/:number" do
  @number = params[:number].to_i
  redirect "/" unless (1..@table_of_contents.size).cover?(@number)
  
  @title = "Chapter #{@number}: #{@table_of_contents[@number - 1]}"
  @chapter = contents(@number)
  
  erb :chapter
end

get "/search" do
  @number = -1
  @title = "Search"
  @results = search_chapters(params[:query]) if !params[:query].nil?
  erb :search
end

not_found do
  redirect "/"
end