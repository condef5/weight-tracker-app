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
    post "/register", { name:'lucas', email: 'test@email.com', password: "123123", gender: "female" }
    get '/'
    expect(last_response.status).to eq 200 
    expect(last_response.body).to include("Successful user registration") 
  end
  
  it "returns error when user registered with duplicate email" do
    post "/register", { name:'lucas', email: 'test@email.com', password: "123123", gender: "female" }
    get '/register'
    expect(last_response.status).to eq 200 
    expect(last_response.body).to include("User already existed")
  end
  
  it "returns error when user registered without password" do
    post "/register", { name:'lucas', email: 'test@email.com', gender: "female"}
    get '/register'
    expect(last_response.body).to include("You need to enter a password")

  end
  it "return status 302 when user set your goal weigth and not registered" do
    post "/save_weight_wanted", { weight_wanted: 76}
    expect(last_response.body).to eq ""
    expect(last_response.status).to eq 302
  end
  
  it "return message successfull when user set your goal weigth and registered" do
    post "/save_weight_wanted", { weight_wanted: 76}, 'rack.session' => { :user_email => "test@email.com" }
    get "/"
    expect(last_response.body).to include("You Have modified your Goal Weight")
    expect(last_response.status).to eq 200
  end
  
  it "return status 302 when user add new measure" do
    post "/adding_measures", { weight: 72.3, height: 1.76}, 'rack.session' => { :user_email => "test@email.com" }
    get "/"
    expect(last_response.body).to include("Measures added!")
    expect(last_response.status).to eq 200
  end

  it "return status 404 when address is unknown" do
   get "/suifnhsufvhasudhasdn"
   expect(last_response.status).to eq 404
  end

  it "return error when user want add new measure the same day" do
    get '/measure/new', {}, 'rack.session' => { :user_email => "test@email.com" }
    get "/" #
    expect(last_response.body).to include("You have already registered your measurements")
  end

  # remove user test
  User::delete('test@email.com')
end