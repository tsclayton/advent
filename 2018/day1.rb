#!/usr/bin/env ruby

def parse_file_to_ints(filename)
  nums = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      nums << line.gsub(/[\s+]+/, '').to_i
    end
  end

  nums
end

def sum(arr)
  arr.reduce(:+)
end

def first_repeated_freq(arr)
  freq_hash = {}
  curr_freq = 0

  while true
    arr.each do |num|
      return curr_freq if freq_hash[curr_freq] != nil
      freq_hash[curr_freq] = true
      curr_freq += num
    end
  end
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
  puts("EXAMPLE SOLUTIONS:")
  puts(first_repeated_freq([1, -1]))
  puts(first_repeated_freq([3, 3, 4, -2, -4]))
  puts(first_repeated_freq([-6, 3, 8, 5, -6]))
  puts(first_repeated_freq([7, 7, -2, -7, -4]))
  puts("INPUT SOLUTION:")
  file_input = parse_file_to_ints("day1_input.txt")
  puts(first_repeated_freq(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
