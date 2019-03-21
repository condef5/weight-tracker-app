# generateCSV uses data.json to generate the admin required CSV file

require "csv"
require "json"
require_relative "../models/User"

# name archive by date
filename = Time.now.strftime("%Y%m%d")

# get json and parse it
# my_hashes = JSON.parse(File.open("data.json").read)

# using class User to parse the Json file
user = User.all

# get all keys even the ones in nested array
# cell_title = my_hashes.first.keys.first(4) + my_hashes.first["measures"].first.keys

# setting column titles for CSV file
cell_title = ["email", "name", "genre", "set_milestone", "date", "height", "weight"]

# open CSV file
CSV.open("#{filename}.csv", "w") do |csv|
  # write completed column names
  csv << cell_title
# using main defined classes
  user.each do |userdata|
    userdata.measures.each do |each_measure|
      temp = []
      temp = [userdata.email, userdata.name, userdata.gender, userdata.set_milestone, each_measure.date, each_measure.height, each_measure.weight]

# writing rows of data in CSV
      csv << temp
    end
  end

end