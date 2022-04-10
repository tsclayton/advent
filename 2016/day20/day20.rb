#!/usr/bin/env ruby

def get_blacklist_from_file(filename)
  blacklist = []

  File.read(filename).split("\n").each do |line|
    range = line.scan(/[0-9]+/).map(&:to_i)
    blacklist << {min: range[0], max: range[1]}
  end

  blacklist
end

def lowest_nonclocked_ip(blacklist)
  blacklist.sort_by! { |range| range[:min] }
  min_ip = 0

  blacklist.each do |range|
    break if min_ip < range[:min]

    min_ip = range[:max] + 1 if min_ip <= range[:max]
  end

  min_ip
end

def num_unblocked_ips(blacklist, max_ip)
  blacklist.sort_by! { |range| range[:min] }

  num_ips = blacklist[0][:min]
  curr_max_blocked = 0

  for i in 0...blacklist.length
    num_ips += blacklist[i][:min] - curr_max_blocked - 1 if blacklist[i][:min] > curr_max_blocked
    curr_max_blocked = blacklist[i][:max] if blacklist[i][:max] > curr_max_blocked
  end

  num_ips += (max_ip - curr_max_blocked)

  num_ips
end

def part_1_examples
  puts('PART 1 EXAMPLE SOLUTIONS:')
  blacklist = [
    {min: 5, max: 8},
    {min: 0, max: 2},
    {min: 4, max: 7}
  ]
  puts(lowest_nonclocked_ip(blacklist))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  puts(lowest_nonclocked_ip(get_blacklist_from_file('day20_input.txt')))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  blacklist = [
    {min: 5, max: 8},
    {min: 0, max: 2},
    {min: 4, max: 7}
  ]
  puts(num_unblocked_ips(blacklist, 9))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  puts(num_unblocked_ips(get_blacklist_from_file('day20_input.txt'), 4_294_967_295))
end

part_1_examples()
part_1_final()
part_2_example()
part_2_final()