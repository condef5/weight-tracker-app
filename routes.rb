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
  @user_data = User::find("diego@mail.com")
  erb :view_measures
end

set :port, 8000
