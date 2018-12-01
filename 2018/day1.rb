#!/usr/bin/env ruby

def parse_file_to_ints(filename)
  File.open(filename, "r") do |file|
    file.each_line do |line|
      return line.gsub(/[\s+]+/, '').to_i
    end
  end
end

def sum(arr)
  arr.reduce(:+)
end

def part_1
  puts("EXAMPLE SOLUTIONS:")
  puts(sum([1, 1, 1]))
  puts(sum([1, 1, -2]))
  puts(sum([-1, -2, -3]))
  puts("INPUT SOLUTION:")
  file_input = parse_file_to_ints("day1_input.txt")
  puts(sum(file_input))
end

def part_2
end

puts("PART 1 SOLUTIONS:")
part_1()
# puts("PART 2 SOLUTIONS:")
# part_2()
