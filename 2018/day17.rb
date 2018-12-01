#!/usr/bin/env ruby

def run_spin_lock(iterations, num_steps)
  buffer = [0]
  curr_index = 0

  for i in 1..iterations
    curr_index = ((curr_index + num_steps) % buffer.length) + 1
    buffer = buffer[0...curr_index] + [i] + buffer[curr_index...buffer.length]
  end

  buffer
end

def value_after_last_written(iterations, num_steps)
  buffer = run_spin_lock(iterations, num_steps)
  last_written_index = buffer.find_index(iterations)
  buffer[(last_written_index + 1 ) % buffer.length]
end

def value_after_zero(iterations, num_steps)
  buffer_length = 1
  curr_index = 0
  last_value_after_zero = 0

  # fake spin lock
  for i in 1..iterations
    curr_index = ((curr_index + num_steps) % buffer_length) + 1
    last_value_after_zero = i if curr_index == 1
    buffer_length += 1
  end

  last_value_after_zero
end

def part_1
  puts("EXAMPLE SOLUTION:")
  puts(value_after_last_written(2017, 3))
  puts("INPUT SOLUTION:")
  puts(value_after_last_written(2017, 312))
end

def part_2
  puts("INPUT SOLUTION:")
  puts(value_after_zero(50_000_000, 312))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
