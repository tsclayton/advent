#!/usr/bin/env ruby

def parse_file(filename)
  lines = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      lines << line.gsub(/\s+/, ' ').split(' ').map(&:to_i)
    end
  end

  return lines[0]
end

def num_cycles_to_infinite_loop(banks)
  num_cycles = 0
  memory_states = {}

  while true
    state_key = banks.join(",")
    break if memory_states[state_key] != nil

    memory_states[state_key] = num_cycles

    max_blocks = 0
    block_index = 0

    for i in 0...banks.length
      if banks[i] > max_blocks
        max_blocks = banks[i]
        block_index = i
      end
    end

    blocks_to_distribute = max_blocks
    banks[block_index] = 0

    while blocks_to_distribute > 0
      block_index = (block_index + 1) % banks.length
      banks[block_index] += 1
      blocks_to_distribute -= 1
    end

    num_cycles += 1
  end

  return num_cycles
end

# same as above, just return a different thing
def length_of_infinite_loop(banks)
  num_cycles = 0
  memory_states = {}

  while true
    state_key = banks.join(",")
    if memory_states[state_key] != nil
      return num_cycles - memory_states[state_key]
    end

    memory_states[state_key] = num_cycles

    max_blocks = 0
    block_index = 0

    for i in 0...banks.length
      if banks[i] > max_blocks
        max_blocks = banks[i]
        block_index = i
      end
    end

    blocks_to_distribute = max_blocks
    banks[block_index] = 0

    while blocks_to_distribute > 0
      block_index = (block_index + 1) % banks.length
      banks[block_index] += 1
      blocks_to_distribute -= 1
    end

    num_cycles += 1
  end

  return num_cycles
end

def part_1
  puts("EXAMPLE SOLUTION:")
  puts(num_cycles_to_infinite_loop([0, 2, 7, 0]))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day6_input.txt")
  puts(num_cycles_to_infinite_loop(file_input))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  puts(length_of_infinite_loop([0, 2, 7, 0]))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day6_input.txt")
  puts(length_of_infinite_loop(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
