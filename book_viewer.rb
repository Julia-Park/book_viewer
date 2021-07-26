require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

before do
  @table_of_contents = File.readlines("data/toc.txt")
  @number = 0
end

helpers do
  def format_html(paragraphs) # => string with <p> tags where id=paragraph idx
    result = ""

    paragraphs.each_with_index do |paragraph, idx|
      result += "<p id=#{idx + 1}>#{paragraph}</p>"
    end

    result
  end

  def contents(chapter_number) # => array of paragraphs
    File.read("data/chp#{chapter_number}.txt").split("\n\n")
  end

  def highlight(text, term)
    text.gsub(term) { |match| "<strong>#{match}</strong>" }
  end

  def search_chapters(query) # => hash {chp#: { 'title': ... , p_ix: paragraph  }}
    result = {}
    return result if query == ""
    search_term = Regexp.new(query, Regexp::IGNORECASE)

    @table_of_contents.each_with_index do |title, title_idx|
      chapter_num = title_idx + 1
      if title.match?(search_term)
        result[chapter_num] = 
          { "link" => "/chapters/#{chapter_num}" }
        result[chapter_num]["title"] = highlight(title, search_term)
      end

      contents(chapter_num).each_with_index do |paragraph, p_idx|
        if paragraph.match?(search_term)
          if result[chapter_num].nil?
            result[chapter_num] = 
              { "title" => title, "link" => "/chapters/#{chapter_num}"}
          end
          
          result[chapter_num][p_idx + 1] = highlight(paragraph, search_term)
        end
      end
    end

    result
  end

  def html_link(url, link_text, attributes = "")
    "<a href=""#{url}"" #{attributes}>#{link_text}</a>"
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