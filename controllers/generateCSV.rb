require "csv"
require "json"

filename = Time.now.strftime("%Y%m%d")
# puts filename

my_hashes = JSON.parse(File.open("./../data.json").read)
# puts my_hashes

CSV.open("#{filename}.csv", "w") do |csv|
  csv << my_hashes.first.keys
  my_hashes.each { |hash| csv << hash.values }
end