#!/usr/bin/env ruby

def get_wires_from_file(filename)
  wires = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      subbed_line = line.gsub(/\s+/, '')
      wires << get_wire_from_string(subbed_line)
    end
  end

  wires
end

def get_wire_from_string(string)
  directions = []

  split_string = string.split(',')
  split_string.each do |direction_string|
    direction = {}

    case direction_string[0]
    when 'U'
      direction[:direction] = :up
    when 'D'
      direction[:direction] = :down
    when 'L'
      direction[:direction] = :left
    when 'R'
      direction[:direction] = :right
    end

    direction[:value] = direction_string[1...direction_string.length].to_i
    directions << direction
  end

  directions
end

def get_intersections(wires)
  grid = {}
  intersections = []

  for i in 0...wires.length
    directions = wires[i]
    curr_point = [0, 0]
    step_count = 0

    directions.each do |direction|
      dir_vector = [1, 0]
      case direction[:direction]
      when :left
        dir_vector = [-1, 0]
      when :up
        dir_vector = [0, 1]
      when :down
        dir_vector = [0, -1]
      end

      for j in 0...direction[:value]
        curr_point[0] += dir_vector[0]
        curr_point[1] += dir_vector[1]
        step_count += 1

        grid[curr_point[0]] ||= {}

        if grid[curr_point[0]][curr_point[1]].nil?
          grid[curr_point[0]][curr_point[1]] = {wire: i, step_count: step_count}
        elsif grid[curr_point[0]][curr_point[1]][:wire] != i
          intersections << {point: [curr_point[0], curr_point[1]], step_count_1: grid[curr_point[0]][curr_point[1]][:step_count], step_count_2: step_count}
        end
      end
    end
  end

  intersections
end

def closest_intersection(wires)
  intersections = get_intersections(wires)
  closest_distance = nil

  intersections.each do |intersection|
    distance = intersection[:point].map(&:abs).reduce(:+)
    if closest_distance.nil? || distance < closest_distance
      closest_distance = distance
    end
  end

  closest_distance
end

def lowest_signal_delay_intersection(wires)
  intersections = get_intersections(wires)
  lowest_delay = nil

  intersections.each do |intersection|
    total_step_count = intersection[:step_count_1] + intersection[:step_count_2]
    if lowest_delay.nil? || total_step_count < lowest_delay
      lowest_delay = total_step_count
    end
  end

  lowest_delay
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  puts(closest_intersection([get_wire_from_string("R8,U5,L5,D3"), get_wire_from_string("U7,R6,D4,L4")]))
  puts(closest_intersection([get_wire_from_string("R75,D30,R83,U83,L12,D49,R71,U7,L72"), get_wire_from_string("U62,R66,U55,R34,D71,R55,D58,R83")]))
  puts(closest_intersection([get_wire_from_string("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"), get_wire_from_string("U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")]))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  puts(closest_intersection(get_wires_from_file("day3_input.txt")))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  puts(lowest_signal_delay_intersection([get_wire_from_string("R8,U5,L5,D3"), get_wire_from_string("U7,R6,D4,L4")]))
  puts(lowest_signal_delay_intersection([get_wire_from_string("R75,D30,R83,U83,L12,D49,R71,U7,L72"), get_wire_from_string("U62,R66,U55,R34,D71,R55,D58,R83")]))
  puts(lowest_signal_delay_intersection([get_wire_from_string("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"), get_wire_from_string("U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")]))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  puts(lowest_signal_delay_intersection(get_wires_from_file("day3_input.txt")))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()
