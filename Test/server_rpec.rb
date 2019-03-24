require "rspec"
require 'rack/test'
require_relative '../routes'
require_relative '../models/User'

describe "Weight Tracker App" do
  include Rack::Test::Methods
 
  def app
    Sinatra::Application
  end
 
  it "returns status 302 when the user has not logged in" do
    get "/"
    expect(last_response.body).to eq("")
    expect(last_response.status).to eq 302
  end

  it "returns status 200 when the user has logged in" do
    get '/', {}, 'rack.session' => { :user_email => "diego@mail.com" }
    expect(last_response).to be_ok
  end

  it "returns status 200 when user registered successfull" do
    post "/register", { name:'lucas', email: 'data@email.com', password: "123123", gender: "female" }
    get '/'
    expect(last_response.status).to eq 200 
    expect(last_response.body).to include("Successful user registration") 
  end
  
  it "returns error when user registered with duplicate email" do
    post "/register", { name:'lucas', email: 'data@email.com', password: "123123", gender: "female" }
    get '/register'
    expect(last_response.status).to eq 200 
    expect(last_response.body).to include("User already existed") 
    # remove user test
    User::delete('data@email.com')
  end
  
  it "returns error when user registered without password" do
    post "/register", { name:'lucas', email: 'data@email.com', gender: "female"}
    get '/register'
    expect(last_response.body).to include("You need to enter a password")
    # remove user test
    User::delete('data@email.com')
  end
end
