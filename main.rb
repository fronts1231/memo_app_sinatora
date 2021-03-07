require 'sinatra'
require 'sinatra/reloader'
require 'csv'
$stdout.sync = true

get '/' do
  @main_title = 'メモアプリ'
  @subtitle = 'show saved notes here'
  @titles = CSV.read('data.csv').map{|row| row[0]}
  erb :index
end

get '/new' do
  @main_title = 'メモアプリ'
  @subtitle = 'create new note here'
  @title = ''
  @content = ''
  erb :add_item
end

get '/:id' do |n|
  @main_title = 'メモアプリ'
  data = CSV.read('data.csv')[n.to_i]
  p(data)
  @title = data[0]
  @content = data[1]
  @index = n
  erb :show_item
end

get '/:name/edit' do |n|
  @main_title = 'メモアプリ'
  data = CSV.read('data.csv')[n.to_i]
  @title = data[0]
  @content = data[1]
  @button = "save"
  @directory = "/"
  @index = n
  erb :edit_item
end

post '/' do
  @main_title = 'メモアプリ'
  @subtitle = 'show saved notes here'
  
  # CSV.table('data.csv') << CSV::Row.new([title,content],[params[:title],params[:content]])
  
  data = CSV.open('data.csv','a')
  data.puts([params[:title],params[:content]])
  data.close

  @titles = CSV.table('data.csv').map{|row| row[0]}
  
  erb :index
end

delete '/:id/deleted' do |n|
  @main_title = 'メモアプリ'
  @subtitle = 'this item has been deleted'
  
  data = CSV.read('data.csv')
  data.delete_at(n.to_i)
  CSV.open('data.csv','w') do |row|
    data.each do |item| 
      row.puts(item)
    end
  end
  
  erb :deleted
end

patch '/:id/edited' do |n|
  @main_title = 'メモアプリ'
  @subtitle = 'this item has been updated'
  
  data = CSV.read('data.csv')
  data[n.to_i] = [params[:title],params[:content]]
  CSV.open('data.csv','w') do |row|
    data.each do |item| 
      row.puts(item)
    end
  end
  
  erb :edited
end
