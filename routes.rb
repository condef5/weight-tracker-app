require 'sinatra'
require 'sinatra/reloader' # reload server

get '/' do
  erb :login
end

get '/user' do
  erb :user
end

set :port, 8000
