#!/usr/bin/env ruby

def get_bus_info_from_file(filename)
  split_file = File.read(filename).split("\n")

  departure = split_file[0].to_i
  buses_in_service = []
  sequential_offsets = []
  split_buses = split_file[1].split(',')

  for i in 0...split_buses.length
    next if split_buses[i] == 'x'

    buses_in_service << split_buses[i].to_i
    sequential_offsets << i
  end

  {departure: departure, buses_in_service: buses_in_service, sequential_offsets: sequential_offsets}
end

def soonest_arriving_bus_product(bus_info)
  soonest_bus = 0
  shortest_wait = Float::INFINITY

  bus_info[:buses_in_service].each do |bus|
    wait_time = bus - (bus_info[:departure] % bus)
    if wait_time < shortest_wait
      soonest_bus = bus
      shortest_wait = wait_time
    end
  end

  shortest_wait * soonest_bus
end

def pow_mod(x, n, m)
  y = 1

  while n > 0
    y = y * x % m if n.odd?
    n = n / 2
    x = x * x % m
  end

  y
end

def inverse(x, m)
  pow_mod(x, m - 2, m)
end

def smallest_sequential_bus_time(bus_info)
  m = bus_info[:buses_in_service].reduce(:*)

  ms = []
  ys = []
  as = []

  for i in 0...bus_info[:buses_in_service].length
    bus = bus_info[:buses_in_service][i]
    mi = (bus_info[:buses_in_service] - [bus]).reduce(:*)
    ms << mi
    ys << inverse(mi, bus)
    as << bus - bus_info[:sequential_offsets][i]
  end

  total = 0

  for i in 0...bus_info[:buses_in_service].length
    total += (as[i] * ms[i] * ys[i])
  end

  total % m
end

def lcm(a, b)
  gcd = 1
  potential_max = [a, b].min
  for i in 1..potential_max
    gcd = i if a % i == 0 && b % i == 0
  end

  (a * b) / gcd
end

def lowest_common_multiple(bus_info)
  thing = bus_info[:buses_in_service][0]

  for i in 1...bus_info[:buses_in_service].length
    thing = lcm(thing, bus_info[:buses_in_service][i])
  end

  thing
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  puts(soonest_arriving_bus_product({departure: 939, buses_in_service: [7, 13, 59, 31, 19], sequential_offsets: [0, 1, 4, 6, 7]}))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  bus_info = get_bus_info_from_file('day13_input.txt')
  puts "bus_info: #{bus_info}"
  puts(soonest_arriving_bus_product(bus_info))
end

def part_2_examples
  puts('PART 2 EXAMPLE SOLUTIONS:')
  puts(smallest_sequential_bus_time({departure: 939, buses_in_service: [7, 13, 59, 31, 19], sequential_offsets: [0, 1, 4, 6, 7]}))
  puts(smallest_sequential_bus_time({departure: 939, buses_in_service: [17, 13, 19], sequential_offsets: [0, 2, 3]}))
  puts(smallest_sequential_bus_time({departure: 939, buses_in_service: [67, 7, 59, 61], sequential_offsets: [0, 1, 2, 3]}))
  puts(smallest_sequential_bus_time({departure: 939, buses_in_service: [67, 7, 59, 61], sequential_offsets: [0, 2, 3, 4]}))
  puts(smallest_sequential_bus_time({departure: 939, buses_in_service: [67, 7, 59, 61], sequential_offsets: [0, 1, 3, 4]}))
  puts(smallest_sequential_bus_time({departure: 939, buses_in_service: [1789, 37, 47, 1889], sequential_offsets: [0, 1, 2, 3]}))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  bus_info = get_bus_info_from_file('day13_input.txt')
  puts(smallest_sequential_bus_time(bus_info))
end

part_1_example()
part_1_final()
part_2_examples()
part_2_final()