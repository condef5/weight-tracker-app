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
  begin  
    User.create(params)
    session[:user_email] = params["email"]
    flash[:message] = "Successful user registration"
    flash[:message_type] = "is-success"
    redirect '/'
  rescue StandardError => e
    flash[:message] = e.message
    flash[:message_type] = "is-danger"
    redirect '/'
  end 
  
end

get '/login' do
  erb :login, :locals => { :hero => true }
end

post '/login' do
  begin
    user = User.find_login(params["email"], params["password"])
    session[:user_email] = params["email"]
    redirect '/'
  rescue StandardError => e
    flash[:message] = e.message
    flash[:message_type] = "is-danger"
    redirect '/login'
  end 
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/user' do
  erb :user
end

###----christoph
get '/milestone' do
  erb :milestone
end

post "/save_weight_wanted" do
  # store_weight_wanted(params["weight_w"])
  puts params["weight_wanted"]
  # "Ok!"
  redirect "/user"
end
###--

set :port, 8000


