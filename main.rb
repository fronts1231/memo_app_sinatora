require 'sinatra'
require 'sinatra/reloader'
require 'csv'

get '/' do
  @title = 'メモアプリ'
  @subtitle = 'show saved notes here'
  erb :index
end

get '/new' do
  @title = 'メモアプリ'
  @subtitle = 'create new note here'
  @button = 'send'
  erb :edit
end

get '/:name' do |n|
  @title = 'メモアプリ'
  @subtitle = "show #{n} content here"
  erb :index
end

get '/:name/edit' do |n|
  @title = 'メモアプリ'
  @subtitle = "edit #{n} here"
  @button = "edit"
  erb :edit
end

post '/' do
  @title = 'メモアプリ'
  @subtitle = 'show saved notes here'

  data = CSV.open('data.csv','a')
    data.puts [params[:title],params[:content]]
  data.close
  
  @titles = CSV.read('data.csv').map{|row| row[0]}
  erb :index
end
