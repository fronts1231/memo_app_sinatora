require 'sinatra'
require 'sinatra/reloader'
require 'csv'
include ERB::Util
$stdout.sync = true

helpers do
  def escape(text)
    html_escape(text)
  end
end

get '/' do
  @main_title = MAIN_TITLE
  @titles = CSV.read(DATA_FILE).map{|row| row[0]}
  erb :index
end

get '/new' do
  @main_title = MAIN_TITLE
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

get '/:name/edit' do |n|
  @main_title = MAIN_TITLE
  data = CSV.read(DATA_FILE)[n.to_i]
  @title = data[0]
  @content = data[1]
  @button = "save"
  @directory = "/"
  @index = n
  erb :edit_item
end

post '/new/confirm' do
  @main_title = MAIN_TITLE
  @subtitle = 'new item created as below'
  
  if escape(params[:title]) != ''
    @title = escape(params[:title])
    @content = escape(params[:content])
    data = CSV.open(DATA_FILE,'a')
      data.puts([@title,@content])
    data.close
    @titles = CSV.table(DATA_FILE).map{|row| row[0]}

  else
    @subtitle = 'title cannot be blank'
  end
  erb :confirm
end

delete '/:id/deleted' do |n|
  @main_title = MAIN_TITLE
  @subtitle = 'this item has been successfully deleted'
  data = CSV.read(DATA_FILE)
  data.delete_at(n.to_i)
  CSV.open(DATA_FILE,'w') do |row|
    data.each do |item| 
      row.puts(item)
    end
  end
  erb :confirm
end

patch '/:id/edit/confirm' do |n|
  @main_title = MAIN_TITLE
  @index = n
  
  if escape(params[:title]) != ''
    @subtitle = 'this item has been successfully updated as below'
    @title = escape(params[:title])
    @content = escape(params[:content])
    data = CSV.read(DATA_FILE)
    data[n.to_i] = [@title,@content]
    CSV.open(DATA_FILE,'w') do |row|
      data.each do |item| 
        row.puts(item)
      end
    end
    
  else
    @subtitle = 'title cannot be blank'
  end
  erb :confirm
end
  