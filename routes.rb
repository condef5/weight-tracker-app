require 'sinatra'
require 'sinatra/reloader' # reload server
require './models/User.rb'

get '/' do
  erb :login
end

# get '/user' do
#   erb :user
# end

get "/view_measures" do
  @user_data = User.find("diego@mail.com")
  if params.empty?
    params["milestone"] = "fixed"
  end
  erb :view_measures, { :locals => params }
end

set :port, 8000
