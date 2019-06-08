require '../models/User'

RSpec.describe "Test Classes" do

  describe "Test User Class" do
    User.change_file("data.json")

    it "All method should return all users data" do
        expect(User.all.map {|user| user.name}).to eq(["Name 1", "Name 2", "Name 3"])
        expect(User.all.map {|user| user.email}).to eq(["test1@mail.com", "test2@mail.com", "test3@mail.com"])
    end

    it "Find method should return a specific user data" do
      expect(User.find("test1@mail.com").name).to eq("Name 1")
      expect(User.find("test3@mail.com").gender).to eq("male")
    end

    it "weight_variation method should calculate the weight variation compare to the last register with a + and - prepended" do
      user = User.find("test1@mail.com")
      expect(user.weight_variation(0).to_s).to eq("+1.0")
      expect(user.weight_variation(1).to_s).to eq("-0.5")
    end

    it "height_variation method should calculate the height variation compare to the last register with a + and - prepended" do
      user = User.find("test1@mail.com")
      expect(user.height_variation(0).to_s).to eq("+0.0")
      expect(user.height_variation(1).to_s).to eq("+0.01")
    end

    it "bmi_variation method should calculate the bmi variation compare to the last register with a + and - prepended" do
      user = User.find("test1@mail.com")
      expect(user.bmi_variation(0).to_s).to eq("+0.34")
    end

    it "weight_color method should return 'yellowgreen' or 'salmon' if the weight measure is going towards or against a milestone" do
      user = User.find("test1@mail.com")
      expect(user.weight_color(0, "fixed")).to eq("yellowgreen")
      expect(user.weight_color(0, "")).to eq("salmon")
    end

    it "save_data_to_json method should over write the file 'data.json' with new data" do
      User.change_file("test.txt")
      expect{User.save_data_to_json("New")}.to change{File.read("test.txt")}.from("Original").to("New")
      User.save_data_to_json("Original")
    end

    it "read method should read and parse the content of data.json" do
      User.change_file("data.json")
      expect(User.read.first["name"]).to eq("Name 1")
    end

    it "save_measure method should add a new measure to a specific user on the data.json file" do
      old_data = File.read("data.json")
      new_measure = { "date": "03/23/2019", "weight": 70, "height": 1.75 }
      User.save_measure(new_measure, "test1@mail.com")
      expect(User.find("test1@mail.com").measures.first.date).to eq("03/23/2019")
      expect(User.find("test1@mail.com").measures.first.weight).to eq(70)
      expect(User.find("test1@mail.com").measures.first.height).to eq(1.75)
      User.save_data_to_json(old_data)
    end

    it "save_milestone method should over write the 'set_milestone' property on a specific user" do
      user = User.find("test1@mail.com")
      user.save_milestone("80")
      user = User.find("test1@mail.com")
      expect(user.set_milestone).to eq("80")
      user.save_milestone("56")
    end
    it "filtered_by_last method should return an array of hashes which the count of active users" do
      list = User.filtered_by_last(7)
      expect(list[0][:days]).to eq(3)
      expect(list[1][:days]).to eq(2)
      expect(list[2][:days]).to eq(1)
    end
    
  end

end