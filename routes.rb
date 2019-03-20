require 'sinatra'
require 'sinatra/reloader' # reload server

get '/' do
  erb :login
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


