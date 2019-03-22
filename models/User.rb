require 'json'
require 'date'
require_relative 'Measure.rb'

class User
  @@file = 'data.json'

  attr_accessor :email, :name, :gender, :set_milestone, :measures, :password
  
  def initialize(email, name, gender, set_milestone, password, measures)
    @email = email
    @name = name
    @gender = gender
    @set_milestone= set_milestone || ""
    @measures = measures || []
    @password = password || ""
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
    raise 'You need to enter a gender' if user["gender"] == ""
    raise 'You need to enter a password' if user["password"] == ""
    raise 'User already existed' unless self.find(user["email"]).nil?
    users = self.read
    users << user.merge({ measures: [] })
    self.save_data_to_json(users.to_json)
  end

  def self.find_login(email, password)
    user = self.find(email)
    raise 'User not found' if user.nil?
    raise 'Incorrect password' if user.password != password
    return user 
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
        user["password"], 
        self.relation(user["measures"])
      )
    end
  end

  def self.find(email)
    users = self.read
    user = users.detect{ |user| user["email"] ==  email}
    return nil if user.nil?
    self.new(
      user["email"], 
      user["name"], 
      user["gender"], 
      user["set_milestone"],
      user["password"], 
      self.relation(user["measures"])
    )
  end
=begin
  def self.by_last_week
    self.group_and_filter(7)
  end

  def self.by_last_month
    self.group_and_filter(30)
  end
=end
    # method save_milestone
  def self.save_milestone(milestone, email)
    users = self.read
    users = users.map do |user|
      if user["email"] == email
        user["set_milestone"] = milestone
        user
      else
        user
      end
    end
    self.save_data_to_json(users.to_json)
  end

  # Code common in self.by_last_week and self.by_last_month
  def self.filtered_by_last(pointer)
    now = Date.today
    filter = (now - pointer).strftime("%m/%d/%y")
    users = self.all
    last_users = users.map do |user|
      days = user.measures.select { |m| m.date >= filter }.length
      { :name => user.name, :days => days }
    end
    puts " from Group and filter: #{last_users.sort { |a, b| b[:days] <=> a[:days]}}"
    last_users.sort { |a, b| b[:days] <=> a[:days]}
  end
end
