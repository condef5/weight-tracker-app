require 'sinatra'
require 'sinatra/reloader' # reload server
require 'sinatra/flash'
require_relative 'models/User'
require_relative 'controllers/generateCSV'
require './helpers'

enable :sessions

#helper = helpers.new

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

get "/admin" do
  redirect "/admin/week"
end

get "/admin/week" do
  @data = User.by_last_week
  erb :admin
end

get "/admin/month" do
  @data = User.by_last_month
  erb :admin
end

get '/admin/download' do
  fileCSV = generateCSV
  content_type "application/csv"
  attachment "data.csv"
  fileCSV
end

#helper = helpers.new
get '/milestone' do
    protected!
    measure_last = @current_user.measures.first
    @ideal_weight = measure_last.calc_ideal_weight(@current_user.gender)
    set_flash("You Have modified your Goal Weight")
    erb :milestone
end

post "/save_weight_wanted" do
  protected!
  @current_user.save_milestone(params["weight_wanted"])
  redirect "/view_measures?milestone=set_by_user"
end

set :port, 8000


