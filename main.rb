require 'sinatra'
require 'sinatra/reloader'
require 'csv'

get '/' do
  @main_title = 'メモアプリ'
  @subtitle = 'show saved notes here'
  erb :index
end

get '/new' do
  @main_title = 'メモアプリ'
  @subtitle = 'create new note here'
  @button = 'send'
  erb :edit
end

get '/:name' do |n|
  @main_title = 'メモアプリ'
  data = CSV.read('data.csv')[n.to_i]
  @title = data[0]
  @content = data[1]
  @button = "edit"
  erb :show_item
end

get '/:name/edit' do |n|
  @main_title = 'メモアプリ'
  erb :edit_item
end

post '/' do
  @main_title = 'メモアプリ'
  @subtitle = 'show saved notes here'

  data = CSV.open('data.csv','a')
    data.puts [params[:title],params[:content]]
  data.close
  
  @titles = CSV.read('data.csv').map{|row| row[0]}
  erb :index
end
