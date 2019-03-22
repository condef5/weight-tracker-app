# generateCSV uses data.json to generate the admin required CSV file

require "csv"
require "json"
require_relative "../models/User"

def generateCSV
  # name archive by date
  filename = Time.now.strftime("%Y%m%d")

  # using class User to parse the Json file
  users = User.all

  # setting column titles for CSV file
  cell_title = ["email", "name", "genre", "set_milestone", "date", "height", "weight"]

  # open CSV file
  CSV.generate do |csv|
    # write completed column names
    csv << cell_title
  # using main defined classes
    users.each do |userdata|
      temp_user = []
      temp_user = [userdata.email,userdata.name, userdata.gender, userdata.set_milestone]
      # Check if userdata.measures is empty, if it is, set dummy data to show user
      if userdata.measures.empty?
        csv << temp_user + [0,0,0]
      else
        userdata.measures.each do |measure|
          temp_measure = []
          temp_measure = [measure.date, measure.height, measure.weight]
    # writing rows of data in CSV
          csv << temp_user + temp_measure
        end
      end
    end

  end
end
