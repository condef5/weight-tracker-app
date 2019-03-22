require 'sinatra'
require 'sinatra/reloader' # reload server
require 'sinatra/flash'
require_relative 'models/User'
require_relative 'controllers/generateCSV'
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
  protected!
  if params.empty?
    params["milestone"] = "fixed"
  end
  erb :view_measures, { :locals => params }
end

get "/admin" do
  redirect "/admin/week"
end

get "/admin/week" do
  @title = "Most active users by week"
  @data = User.filtered_by_last(7)
  erb :admin
end

get "/admin/month" do
  @title = "Most active users by month"
  @data = User.filtered_by_last(30)
  erb :admin
end

get '/admin/download' do
  fileCSV = generateCSV
  content_type "application/csv"
  attachment "data.csv"
  fileCSV
end

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


get '/measure/new' do
  protected!
  #Feature 1 - "Restricted to one time per day, per user" IN PROGRESS
  #@current_user_email = User.find(session[:user_email]).email
  
  erb :add_measures
end

post '/adding_measures' do
  protected!
  new_measure = {
    date: Time.now.strftime("%m/%d/%Y"),
    weight: params["weight"].to_f,
    height: params["height"].to_f
  }
  User.save_measure(new_measure, @current_user.email)
  set_flash("Measures added!")
  redirect "/view_measures"
end

set :port, 8000
