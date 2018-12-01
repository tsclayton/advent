#!/usr/bin/env ruby

def get_lines_from_file(filename)
  lines = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      lines << line.gsub(/\s+/, ' ').split(' ')
    end
  end

  lines
end

def max_min_difference(line)
  min_num = nil
  max_num = nil

  line.each do |word|
    curr_num = word.to_i
    min_num = (min_num == nil || curr_num < min_num) ? curr_num : min_num
    max_num = (max_num == nil || curr_num > max_num) ? curr_num : max_num
  end

  return max_num - min_num
end

def divisibility(line)
  for i in 0...(line.length - 1)
    num_1 = line[i].to_i
    for j in (i + 1)...(line.length)
      num_2 = line[j].to_i

      mod = num_1 > num_2 ? num_1 % num_2 : num_2 % num_1
      if (mod == 0)
        return num_1 > num_2 ? num_1 / num_2 : num_2 / num_1
      end
    end
  end

  return 0
end

def calculate_checksum(input, line_op)
  results = []

  input.each do |line|
    results << line_op.call(line)
  end

  return results.reduce {|x, y| x + y }
end

def part_1
  sample_input = [
    ['5', '1', '9', '5'],
    ['7', '5', '3'],
    ['2', '4', '6', '8']
  ]

  puts("EXAMPLE SOLUTION:")
  puts(calculate_checksum(sample_input, method(:max_min_difference)))
  puts("INPUT SOLUTION:")
  file_input = get_lines_from_file("day2_input.txt")
  puts(calculate_checksum(file_input, method(:max_min_difference)))
end


def part_2
  sample_input = [
    ['5', '9', '2', '8'],
    ['9', '4', '7', '3'],
    ['3', '8', '6', '5']
  ]

  puts("EXAMPLE SOLUTION:")
  puts calculate_checksum(sample_input, method(:divisibility))
  puts("INPUT SOLUTION:")
  file_input = get_lines_from_file("day2_input.txt")
  puts calculate_checksum(file_input, method(:divisibility))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
