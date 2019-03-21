require 'sinatra'
require 'sinatra/reloader' # reload server
require 'sinatra/flash'
require './models/User'

enable :sessions

get '/' do
  if session[:user_email]
    @current_user = User.find(session[:user_email]) 
    erb :home
  else
    erb :register, :locals => { :hero => true }
  end
end

post '/register' do
  User::create(params)
  session[:user_email] = params["email"]
  flash[:message] = "Successful user registration"
  redirect '/'
end

get '/login' do
  erb :login, :locals => { :hero => true }
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/user' do
  erb :user
end

set :port, 8000
