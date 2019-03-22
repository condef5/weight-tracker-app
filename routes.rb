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
  # puts fileCSV
  content_type "application/csv"
  attachment "data.csv"
  fileCSV
  # send_data fileCSV, :filename => "data.csv", :type => 'Application/octet-stream'
end

get '/milestone' do
  if session[:user_email]
    @current_user = User.find(session[:user_email])
    measure_last = @current_user.measures.first
    @ideal_weight = measure_last.calc_ideal_weight(@current_user.gender)
    erb :milestone
  else
  flash[:message] = "You are not login"
  flash[:message_type] = "is-danger"
  redirect "/login"
  end
end

post "/save_weight_wanted" do
  @current_user = User.find(session[:user_email])
  User.save_milestone(params["weight_wanted"], @current_user.email)
  redirect "/view_measures"

end

get '/add' do
  protected!
  #Feature 1 - "Restricted to one timeperda, per user" IN PROGRESS
  #@current_user_email = User.find(session[:user_email]).email
  
  erb :add_measures
  
end

post '/add' do
protected!
@current_user_email = User.find(session[:user_email]).email
User.save_measure(Hash["date",Time.now.strftime("%m/%d/%Y"),"weight",params["weight"].to_i,"height",params["height"].to_f], @current_user_email )
redirect "/view_measures"

end

set :port, 8000


