require 'sinatra'
require 'sinatra/reloader' # reload server
require 'sinatra/flash'
require_relative './models/User'
require_relative "./controllers/generateCSV"

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
    redirect '/view_measures'
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

# get '/user' do
#   erb :user
# end

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

get "/admin" do
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

set :port, 8000
