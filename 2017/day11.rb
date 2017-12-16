#!/usr/bin/env ruby

def parse_file(filename)
  File.open(filename, "r") do |file|
    file.each_line do |line|
      return line.gsub(/\s+/, '').split(',')
    end
  end
end

def get_direction_vector(direction)
  case direction
  when 'n'
    [0.0, 1.0]
  when 's'
    [0.0, -1.0]
  when 'ne'
    [1.0, 0.5]
  when 'nw'
    [-1.0, 0.5]
  when 'se'
    [1.0, -0.5]
  when 'sw'
    [-1.0, -0.5]
  else
    [0.0, 0.0]
  end
end

def add_direction(hex_coords, direction)
  direction_vector = get_direction_vector(direction)
  hex_coords[0] += direction_vector[0]
  hex_coords[1] += direction_vector[1]
end

def get_shortest_distance(hex_coords)
  distance = 0
  curr_coords = hex_coords.clone

  while true
    if curr_coords[0] == 0.0
      # remaining distance is purely vertical
      distance += curr_coords[1].abs
      break
    elsif (curr_coords[0] / curr_coords[1]).abs == 2
      # remaining distance is purely diagonal
      distance += curr_coords[0].abs
      break
    else
      if curr_coords[0] < 0 && curr_coords[1] <= 0
        add_direction(curr_coords, 'ne')
      elsif curr_coords[0] < 0 && curr_coords[1] > 0
        add_direction(curr_coords, 'se')
      elsif curr_coords[0] > 0 && curr_coords[1] <= 0
        add_direction(curr_coords, 'nw')
      elsif curr_coords[0] > 0 && curr_coords[1] > 0
        add_direction(curr_coords, 'sw')
      end

      distance += 1
    end
  end

  distance
end

def shortest_distance_at_end_point(directions)
  hex_coords = [0, 0]

  directions.each do |direction|
    add_direction(hex_coords, direction)
  end

  get_shortest_distance(hex_coords)
end

def max_distance_in_journey(directions)
  hex_coords = [0, 0]
  max_distance = 0

  directions.each do |direction|
    add_direction(hex_coords, direction)
    max_distance = [max_distance, get_shortest_distance(hex_coords)].max
  end

  max_distance
end

def part_1
  puts("EXAMPLE SOLUTIONS:")
  puts(shortest_distance_at_end_point(['ne', 'ne', 'ne']))
  puts(shortest_distance_at_end_point(['ne', 'ne', 'sw', 'sw']))
  puts(shortest_distance_at_end_point(['ne', 'ne', 's', 's']))
  puts(shortest_distance_at_end_point(['se', 'sw', 'se', 'sw', 'sw']))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day11_input.txt")
  puts(shortest_distance_at_end_point(file_input))
end

def part_2
  puts("EXAMPLE SOLUTIONS:")
  puts(max_distance_in_journey(['ne', 'ne', 'ne']))
  puts(max_distance_in_journey(['ne', 'ne', 'sw', 'sw']))
  puts(max_distance_in_journey(['ne', 'ne', 's', 's']))
  puts(max_distance_in_journey(['se', 'sw', 'se', 'sw', 'sw']))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day11_input.txt")
  puts(max_distance_in_journey(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
