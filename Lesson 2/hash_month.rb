=begin
Создать хэш, содержащий месяцы и количество дней в месяце.
Вывести в хэше те месяцы, у которых количество дней равно 30.
=end


hash_month = {
  january: 31,
  february: 28,
  march: 31,
  april: 30,
  may: 31,
  june: 30,
  july: 31,
  august: 31,
  september: 30,
  october: 31,
  november: 30,
  december: 31
}

hash_month.each { |month, day| puts "#{month}" if day == 30 }
