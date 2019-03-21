require 'sinatra'
require 'sinatra/reloader' # reload server
require "open-uri"
require_relative "./models/User"
require_relative "./controllers/generateCSV"

get '/' do
  erb :login
end

get '/user' do
  erb :user
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
  send_data fileCSV, :filename => "data.csv", :type => 'Application/octet-stream'
end

set :port, 8000
