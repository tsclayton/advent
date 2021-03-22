#!/usr/bin/env ruby

def memory_game(numbers, turns)
  last_turn_spoken = {}

  for i in 0...(turns - 1)
    if i < numbers.length - 1
      last_turn_spoken[numbers[i]] = i
    else
      current_number = numbers[-1]
      next_number = 0
      if !last_turn_spoken[current_number].nil?
        next_number = i - last_turn_spoken[current_number]
      end
      numbers << next_number
      last_turn_spoken[current_number] = i
    end
  end

  numbers[-1]
end

def part_1_examples
  puts('PART 1 EXAMPLE SOLUTIONS:')
  puts(memory_game([0, 3, 6], 10))
  puts(memory_game([1, 3, 2], 2020))
  puts(memory_game([2, 1, 3], 2020))
  puts(memory_game([1, 2, 3], 2020))
  puts(memory_game([2, 3, 1], 2020))
  puts(memory_game([3, 2, 1], 2020))
  puts(memory_game([3, 1, 2], 2020))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  puts(memory_game([1, 20, 11, 6, 12, 0], 2020))
end

# Seems liek the "proper solution" for this one was to determine the repeating pattern, but the input was small enough to terminate, so ¯\_(ツ)_/¯
def part_2_examples
  puts('PART 2 EXAMPLE SOLUTIONS:')
  puts(memory_game([0, 3, 6], 30000000))
  puts(memory_game([1, 3, 2], 30000000))
  puts(memory_game([2, 1, 3], 30000000))
  puts(memory_game([1, 2, 3], 30000000))
  puts(memory_game([2, 3, 1], 30000000))
  puts(memory_game([3, 2, 1], 30000000))
  puts(memory_game([3, 1, 2], 30000000))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  puts(memory_game([1, 20, 11, 6, 12, 0], 30000000))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()