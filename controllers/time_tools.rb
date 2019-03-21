require "date"

# module appTime
  def convert_to_date(string)
    return Date.strptime(string, "%m/%d/%Y")
    # convierte string a Date
  end

  def convert_to_string(date)
    new_date = date.month.to_s + "/" + date.day.to_s + "/" + date.year.to_s
    new_date
  end

  def today
    f = Date.today
    today = convert_to_string(f)
    today
    # devuelve string
  end

  def last_week(string)
    new_date = convert_to_date(string) - 7
    convert_to_string(new_date)
  end

  def last_month(string)
    new_date = convert_to_date(string) - 30
    convert_to_string(new_date)
  end

  def by_last_week
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

  def by_last_month
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

# end

puts "Fecha actual: #{today}"
puts "Hoy menos 7 días: #{last_week(today)}"
puts "Hoy menos 1 mes: #{last_month(today)}"

puts "Ordenado por última semana: #{by_last_week}"
puts "Ordenado por último mes: #{by_last_month}"