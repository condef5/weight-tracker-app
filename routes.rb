require 'sinatra'
require 'sinatra/reloader' # reload server
require 'sinatra/flash'
require_relative 'models/User'
require_relative 'methods'
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
    set_flash("Successful user login")
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

get '/admin' do
  authorized_admin!
  if !params.key? "need" || params["need"] == "week"
    @by_last = "week"
    @data = User.filtered_by_last(7)
  elsif params["need"] == "month"
    @by_last = "month"
    @data = User.filtered_by_last(30)
  end
  erb :admin
end

get '/admin/download' do
  authorized_admin!
  filename = Time.now.strftime("%Y%m%d")
  # file_csv = generate_csv(User.all)
  content_type "application/csv"
  attachment "#{filename}.csv"
  file_csv = generate_csv(User.all)
end

get '/milestone' do
  begin
    protected!
    measure_last = @current_user.measures.first
    @ideal_weight = measure_last.calc_ideal_weight(@current_user.gender)
    erb :milestone
  rescue 
    @ideal_weight="Cannot be calculated : 0"
    erb :milestone
  end 
end

post "/save_weight_wanted" do
  protected!
  @current_user.save_milestone(params["weight_wanted"])
  set_flash("You Have modified your Goal Weight")
  redirect "/?milestone=set_by_user"
end

# view to add your day's measures
get '/measure/new' do
  protected!
  if @current_user.check_last_measure
    set_flash("You have already registered your measurements", :error)
    redirect "/"
  end
  erb :add_measures
end

# redirecting to "view_measures" view
post '/adding_measures' do
  protected!
  new_measure = {
    date: Time.now.strftime("%m/%d/%Y"),
    weight: params["weight"].to_f,
    height: params["height"].to_f
  }
  User.save_measure(new_measure, @current_user.email)
  set_flash("Measures added!")
  redirect "/"
end

# 404 Error!
not_found do
  status 404
  erb :oops
end
