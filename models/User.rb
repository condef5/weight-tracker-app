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

  def self.by_last_week
    now = Date.today
    last_week = (now - 7).strftime("%m/%d/%y")
    # all users
    users = self.all
    last_users = users.map do |user|
      days = user.measures.select { |m| m.date > last_week }.length
      { :name => user.name, :days => days }
    end
    last_users.sort { |a,b| b[:days] <=> a[:days]}
  end

  def height_variation(index)
    return 0 if @measures[index +1].nil?
    last_height = @measures[index +1].height
    diff = (@measures[index].height - last_height).round(2)
    diff >= 0 ? "+#{diff}" : diff
  end

  def weight_variation(index)
    return 0 if @measures[index +1].nil?
    last_weight = @measures[index +1].weight
    diff = (@measures[index].weight - last_weight).round(2)
    diff >= 0 ? "+#{diff}" : diff
  end

  def bmi_variation(index)
    return 0 if @measures[index +1].nil?
    last_bmi = @measures[index +1].calc_bmi
    diff = (@measures[index].calc_bmi - last_bmi).round(2)
    diff >= 0 ? "+#{diff}" : diff
  end

  def weight_color(index, milestone)
    compare = (milestone == "fixed" ? @measures[index].calc_ideal_weight(@gender) : @set_milestone.to_f )
    if compare == ""
      return ""
    elsif weight_variation(index).to_f >= 0 && @measures[index].weight < compare
      "yellowgreen"
    elsif weight_variation(index).to_f < 0 && @measures[index].weight > compare
      "yellowgreen"
    else
      "salmon"
    end
  end

  def self.by_last_month
    now = Date.today
    last_moth = (now - 30).strftime("%m/%d/%y")
    # all users
    users = self.all
    last_users = users.map do |user|
      days = user.measures.select { |m| m.date > last_moth }.length
      { :name => user.name, :days => days }
    end
    last_users.sort { |a, b| b[:days] <=> a[:days]}
  end
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
end
