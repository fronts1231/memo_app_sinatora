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
  if params[:session] == 'new'
    @subtitle = 'new item created'
  elsif params[:session] == 'deleted'
    @subtitle = 'succesfully deleted'
  elsif params[:session] == 'updated'
    @subtitle = 'successfully updated'
  end
  @titles = CSV.read(DATA_FILE).map{|row| row[0]}
  erb :index
end

get '/new' do
  @main_title = MAIN_TITLE
  if params[:session] == 'warning'
    @subtitle = 'title cannot be blank'
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
  if params[:session] == 'warning'
    @subtitle = 'title cannot be blank'
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
    redirect('/?session=new')
  else
    redirect('/new?session=warning')
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
  redirect('/?session=deleted')
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
    redirect('/?session=updated')
    
  else
    redirect("/#{n}/edit?session=warning")
  end
end
