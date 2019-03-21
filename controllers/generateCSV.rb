require "csv"
require "json"

# name archive by date
filename = Time.now.strftime("%Y%m%d")

# get json and parse it
my_hashes = JSON.parse(File.open("./../data.json").read)
# get all keys even teh ones in nested array
cell_title = my_hashes.first.keys.first(4) + my_hashes.first["measures"].first.keys

# open CSV file
CSV.open("#{filename}.csv", "w") do |csv|
  # write completed column names
  csv << cell_title
  my_hashes.each do |hash|
    hash["measures"].each do |mini_hash|
      temp =[] # to clean container
      temp << hash["email"]
      temp << hash["name"]
      temp << hash["gender"]
      temp << hash["set_milestone"]
      temp << mini_hash["date"]
      temp << mini_hash["weight"]
      temp << mini_hash["height"]
      csv << temp # saving content to CSV
    end
  end

end