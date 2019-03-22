class Measure
  attr_accessor :date, :weight, :height

  def initialize(args = {})
    @date = args["date"]
    @weight = args["weight"]
    @height = args["height"]
  end

  def calc_ideal_weight(gender)
    height = @height * 100
    if gender == "male"
      height - 100 - ( (height - 150) / 4 )
    else
      height - 100 - ( (height - 150) / 2.5 )
    end
  end

  def calc_bmi
    (@weight / (@height * @height)).round(2)
  end

end
