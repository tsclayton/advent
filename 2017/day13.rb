#!/usr/bin/env ruby

def parse_file(filename)
  firewall = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      parsed_line = line.gsub(/\s+/, '').split(':')
      firewall[parsed_line[0].to_i] = parsed_line[1].to_i
    end
  end

  # indices not filled in will be nil, which works just fine for our purposes
  firewall
end

def will_scanner_catch(range, picosecond)
  return range == 1 ? true : (picosecond % ((range - 1) * 2) == 0)
end

def trip_severity(firewall, start_time, return_if_caught = false)
  # set this to nil initially because 0 severity means being caught at depth 0
  for i in 0...firewall.length
    scanner_range = firewall[i]

    if scanner_range != nil && will_scanner_catch(scanner_range, i + start_time)
      severity ||= 0
      severity += (i * scanner_range)
      # optimization for part 2
      return severity if return_if_caught
    end
  end

  severity
end

def min_delay_for_safe_passage(firewall)
  delay = 0

  while true
    break if trip_severity(firewall, delay, true) == nil
    delay += 1
  end

  delay
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = parse_file("day13_example.txt")
  puts(trip_severity(example_input, 0))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day13_input.txt")
  puts(trip_severity(file_input, 0))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  example_input = parse_file("day13_example.txt")
  puts(min_delay_for_safe_passage(example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day13_input.txt")
  puts(min_delay_for_safe_passage(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
