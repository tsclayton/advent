#!/usr/bin/env ruby

def get_seats_from_file(filename)
  seats = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      seats << line.gsub(/[\s+]+/, '')
    end
  end

  seats
end

def get_row(seat)
  seat[0...(seat.length - 3)].chars.map {|c| c == 'B' ? 1 : 0}.join('').to_i(2)
end

def get_col(seat)
  seat[(seat.length - 3)...seat.length].chars.map {|c| c == 'R' ? 1 : 0}.join('').to_i(2)
end

def seat_id(seat)
  seat.chars.map {|c| c == 'R' || c == 'B' ? 1 : 0}.join('').to_i(2)
end

def highest_seat_id(seats)
  seats.map {|seat| seat_id(seat)}.max
end

def missing_seat(seats)
  present_seats = []

  seats.each do |seat|
    present_seats[seat_id(seat)] = true
  end

  for i in 0...present_seats.length
    return i if i > 0 && i < present_seats.length - 1 && present_seats[i].nil? && present_seats[i - 1] && present_seats[i + 1]
  end

  return 0
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  puts(get_row('FBFBBFFRLR'))
  puts(get_col('FBFBBFFRLR'))
  puts(seat_id('FBFBBFFRLR'))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  seats = get_seats_from_file("day5_input.txt")
  puts(highest_seat_id(seats))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  seats = get_seats_from_file("day5_input.txt")
  puts(missing_seat(seats))
end

part_1_examples()
part_1_final()
part_2_final()
