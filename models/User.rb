require 'json'
require 'date'
require_relative 'Measure.rb'

class User
  @@file = 'data.json'

  attr_accessor :email, :name, :gender, :set_milestone, :measures
  
  def initialize(email, name, gender, set_milestone, measures)
    @email = email
    @name = name
    @gender = gender
    @set_milestone= set_milestone || ""
    @measures = measures || []
  end

  def self.read
    JSON.parse(File.read(@@file))
  end
  
  def self.save_data_to_json(data)
    File.write('data.json', data)
  end

  def self.relation(measures)
    measures_orders = measures.sort { |a,b| b["date"] <=> a["date"]}
    measures_orders.map do |measures|
      Measure.new(measures)
    end
  end

  def self.create(user)
    users = self.read
    users.push({
      "name" => user["name"],
      "email" => user["email"],
      "gender" => user["gender"],
      "password" => user["password"],
      "measures" => []
    })
    self.save_data_to_json(users.to_json)
  end

  def self.save_measure(measure)
    
  end

  def self.all
    users_json = self.read
    users_json.map do |user|
      self.new(
        user["email"], 
        user["name"], 
        user["gender"], 
        user["set_milestone"], 
        self.relation(user["measures"])
      )
    end
  end

  def self.find(email)
    users = self.read
    user = users.detect{ |user| user["email"] ==  email}
    self.new(
      user["email"], 
      user["name"], 
      user["gender"], 
      user["set_milestone"],
      self.relation(user["measures"])
    )
  end

  def self.by_last_week
    now = Date.today
    last_week = (now - 7).strftime("%m/%d/%y")
    # all users
    users = self.all
    last_users = users.map do |user|
      days = user.measures.select { |m| m.date > last_week }.length
      { :name => user.name, :days => days}
    end
    last_users.sort { |a,b| b[:days] <=> a[:days]}
  end
end
