#!/usr/bin/env ruby

def part_1(num_string)
  sum = 0
  for i in 0...(num_string.length)
    cur_num = num_string[i].to_i
    next_num = num_string[(i + 1) % num_string.length].to_i 
    sum += cur_num if cur_num == next_num
  end

  return sum
end


def part_2(num_string)
  sum = 0
  for i in 0...(num_string.length)
    cur_num = num_string[i].to_i
    next_num = num_string[(i + (num_string.length / 2)) % num_string.length].to_i 
    sum += cur_num if cur_num == next_num
  end

  return sum
end

puts part_2("1212")
puts part_2("1221")
puts part_2("123425")
puts part_2("123123")
puts part_2("12131415")

if ARGV[0] != nil
  puts part_2(ARGV[0])
end
