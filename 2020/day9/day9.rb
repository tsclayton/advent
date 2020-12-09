#!/usr/bin/env ruby

def get_numbers_from_file(filename)
  numbers = []

  File.open(filename, 'r') do |file|
    file.each_line do |line|
      numbers << line.to_i
    end
  end

  numbers
end

def first_invalid_number(numbers, preamble_length)
  for i in (preamble_length + 1)...numbers.length
    valid_number = false

    for j in (i - preamble_length)...(i - 1)
      for k in (j + 1)...i
        sum = numbers[j] + numbers[k]
        valid_number = true if numbers[i] == sum
      end
    end

    return numbers[i] if !valid_number
  end

  -1
end

def contiguous_range_sum(numbers, invalid_number)
  for i in 0...(numbers.length - 1)
    contiguous_sum = numbers[i]

    for j in (i + 1)...numbers.length
      contiguous_sum += numbers[j]

      return numbers[i..j] if contiguous_sum == invalid_number
      break if contiguous_sum > invalid_number
    end
  end

  [0]
end

def encryption_weakness(numbers, preamble_length)
  invalid_number = first_invalid_number(numbers, preamble_length)
  range = contiguous_range_sum(numbers, invalid_number)
  range.min + range.max
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:') 
  numbers = [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576]
  puts(first_invalid_number(numbers, 5))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  numbers = get_numbers_from_file('day9_input.txt')
  puts(first_invalid_number(numbers, 25))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:') 
  numbers = [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576]
  puts(encryption_weakness(numbers, 5))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  numbers = get_numbers_from_file('day9_input.txt')
  puts(encryption_weakness(numbers, 25))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()