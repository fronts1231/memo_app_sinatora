require 'sinatra'
require 'sinatra/reloader'
require 'csv'
$stdout.sync = true

get '/' do
  @main_title = MAIN_TITLE
  @subtitle = 'you can keep your idea here'
  @titles = CSV.read(DATA_FILE).map{|row| row[0]}
  erb :index
end

get '/new' do
  @main_title = MAIN_TITLE
  @subtitle = 'fill the title and content in the form below'
  @title = ''
  @content = ''
  erb :add_item
end

get '/:id' do |n|
  @main_title = MAIN_TITLE
  @subtitle = 'please confirm the content of the selected item'
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
  
  if params[:title] != ''
    @title = params[:title]
    @content = params[:content]
    data = CSV.open(DATA_FILE,'a')
      data.puts([params[:title],params[:content]])
    data.close
    @titles = CSV.table(DATA_FILE).map{|row| row[0]}
    erb :confirm

  else
    @subtitle = 'title can not be blank'
    @title = ''
    @content = ''
    erb :confirm
  end
end

delete '/:id/deleted' do |n|
  @main_title = MAIN_TITLE
  @subtitle = 'this item has been successfully deleted'
  @title = ''
  @content = ''
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
  
  if params[:title] != ''
    @subtitle = 'this item has been successfully updated as below'
    @title = params[:title]
    @content = params[:content]
    data = CSV.read(DATA_FILE)
    data[n.to_i] = [params[:title],params[:content]]
    CSV.open(DATA_FILE,'w') do |row|
      data.each do |item| 
        row.puts(item)
      end
    end
    erb :confirm
    
  else
    @subtitle = 'title can not be blank'
    @title = ''
    @content = ''
    erb :confirm
  end
end
  