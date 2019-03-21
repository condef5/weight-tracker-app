require 'sinatra'
require 'sinatra/reloader' # reload server
require 'sinatra/flash'
require './models/User'
require './helpers'

enable :sessions

get '/' do
  protected!
  if params.empty?
      params["milestone"] = "fixed"
  end
  erb :view_measures, { :locals => params }
end

get '/register' do
  erb :register, :locals => { :hero => true }
end

post '/register' do
  begin  
    User.create(params)
    session[:user_email] = params["email"]
    set_flash("Successful user registration")
    redirect '/'
  rescue StandardError => e
    set_flash(e.message, :error)
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
    set_flash("Successful user registration")
    redirect '/'
  rescue StandardError => e
    set_flash(e.message, :error)
    redirect '/login'
  end 
end

get '/logout' do
  session.clear
  set_flash("You have been successfully logged out!")
  redirect '/'
end

get "/view_measures" do
  # @user_data = User.find("diego@mail.com")
  # if params.empty?
  #   params["milestone"] = "fixed"
  # end
  # erb :view_measures, { :locals => params }
  if session[:user_email]
    @current_user = User.find(session[:user_email])
    if params.empty?
        params["milestone"] = "fixed"
    end
      erb :view_measures, { :locals => params }
  else
    erb :register, :locals => { :hero => true }
  end
end

set :port, 8000
