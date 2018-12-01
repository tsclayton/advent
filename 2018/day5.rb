#!/usr/bin/env ruby

def parse_file(filename)
  numbers = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      numbers << line.to_i
    end
  end

  numbers
end

def plus_one(num)
  return num + 1
end

def three_check_incrementor(num)
  return num >= 3 ? num - 1 : num + 1
end

def num_steps_in_jump_array(jumps, incrementor)
  num_steps = 0
  i = 0

  while true
    prev = i
    i = [i + jumps[i], 0].max
    jumps[prev] = incrementor.call(jumps[prev])
    num_steps += 1
    break if (i >= jumps.length)
  end

  return num_steps
end

def part_1
  puts("EXAMPLE SOLUTION:")
  puts(num_steps_in_jump_array([0, 3, 0, 1, -3], method(:plus_one)))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day5_input.txt")
  puts(num_steps_in_jump_array(file_input, method(:plus_one)))
end


def part_2
  puts("EXAMPLE SOLUTION:")
  puts(num_steps_in_jump_array([0, 3, 0, 1, -3], method(:three_check_incrementor)))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day5_input.txt")
  puts(num_steps_in_jump_array(file_input, method(:three_check_incrementor)))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
