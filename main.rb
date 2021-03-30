require './const.rb'
require 'sinatra'
require 'sinatra/reloader'
require 'csv'
include ERB::Util
enable :sessions
$stdout.sync = true

helpers do
  def escape(text)
    html_escape(text)
  end
end

get '/' do
  @main_title = MAIN_TITLE
  if session
    @subtitle = session[:message]
    session[:message] = ''
  end
  @titles = CSV.read(DATA_FILE).map{|row| row[0]}
  erb :index
end

get '/new' do
  @main_title = MAIN_TITLE
  if session
    @subtitle = session[:message]
    session[:message] = ''
  end
  erb :add_item
end

get '/:id' do |n|
  @main_title = MAIN_TITLE
  data = CSV.read(DATA_FILE)[n.to_i]
  @title = data[0]
  @content = data[1]
  @index = n
  erb :show_item
end

get '/:id/edit' do |n|
  @main_title = MAIN_TITLE
  if session
    @subtitle = session[:message]
    session[:message] = ''
  end
  data = CSV.read(DATA_FILE)[n.to_i]
  @title = data[0]
  @content = data[1]
  @button = "save"
  @directory = "/"
  @index = n
  erb :edit_item
end

post '/new' do
  if escape(params[:title]) != ''
    @title = escape(params[:title])
    @content = escape(params[:content])
    data = CSV.open(DATA_FILE,'a')
      data.puts([@title,@content])
    data.close
    @titles = CSV.table(DATA_FILE).map{|row| row[0]}
    session[:message] = 'new item created'
    redirect to('/')
  else
    session[:message] = 'title cannot be blank'
    redirect to('/new')
  end
end

delete '/:id/deleted' do |n|
  data = CSV.read(DATA_FILE)
  data.delete_at(n.to_i)
  CSV.open(DATA_FILE,'w') do |row|
    data.each do |item| 
      row.puts(item)
    end
  end
  session[:message] = 'succesfully deleted'
  redirect to('/')
end

patch '/:id/edit' do |n|
  @main_title = MAIN_TITLE
  @index = n
  
  if escape(params[:title]) != ''
    data = CSV.read(DATA_FILE)
    data[n.to_i] = [escape(params[:title]),escape(params[:content])]
    CSV.open(DATA_FILE,'w') do |row|
      data.each do |item| 
        row.puts(item)
      end
    end
    session[:message] = 'successfully updated'
    redirect to ('/')
    
  else
    session[:message] = 'title cannot be blank'
    redirect to("/#{n}/edit")
  end
end
