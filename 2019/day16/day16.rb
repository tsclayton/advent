#!/usr/bin/env ruby

def get_numbers_from_file(file)
  File.open(file, "r") do |file|
    file.each_line do |line|
      return line.gsub(/[\s+]+/, '').split('').map(&:to_i)
    end
  end
end

def get_repeating_pattern_value(number_index, output_position)
  pattern = [0, 1, 0, -1]
  output_position
  pattern[((number_index + 1) / (output_position + 1)) % pattern.length]
end

def fft(numbers, phases)
  return numbers if phases == 0

  new_numbers = []

  for i in 0...numbers.length
    repeating_sum = 0

    for j in 0...numbers.length
      repeating_sum += (numbers[j] * get_repeating_pattern_value(j, i))
    end

    new_numbers << (repeating_sum.abs % 10)
  end

  fft(new_numbers, phases - 1)
end

# assumes the numbers provided are from the back half of the signal and uses rules to optimize it
def back_half_fft(numbers, phases)
  return numbers if phases == 0

  new_numbers = []

  back_half_sum = 0
  numbers.reverse_each do |number|
    back_half_sum += number
    new_numbers.unshift(back_half_sum % 10)
  end

  back_half_fft(new_numbers, phases - 1)
end

def first_eight_digits(numbers, phases)
  result = fft(numbers, phases)
  result[0...8].join('')
end

def real_signal(numbers, phases)
  repetitions = 

  offset = numbers[0...7].join('').to_i

  if offset < (numbers.length * 10_000) / 2
    puts "Offset is less than half. Can't feasibly compute this"
    return
  end

  length = (numbers.length * 10_000) - offset
  puts length

  back_half_numbers = []

  while length > 0
    remaining_length = [length, numbers.length].min

    back_half_numbers = numbers[(numbers.length - remaining_length)...numbers.length] + back_half_numbers
    length -= numbers.length
  end

  puts back_half_numbers.length

  result = back_half_fft(back_half_numbers, phases)

  result[0...8].join('')
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
# After 4 phases: 01029498
  puts(first_eight_digits([1,2,3,4,5,6,7,8], 4))
# 80871224585914546619083218645595 becomes 24176176.
  puts(first_eight_digits([8, 0, 8, 7, 1, 2, 2, 4, 5, 8, 5, 9, 1, 4, 5, 4, 6, 6, 1, 9, 0, 8, 3, 2, 1, 8, 6, 4, 5, 5, 9, 5], 100))
# 19617804207202209144916044189917 becomes 73745418.
  puts(first_eight_digits([1, 9, 6, 1, 7, 8, 0, 4, 2, 0, 7, 2, 0, 2, 2, 0, 9, 1, 4, 4, 9, 1, 6, 0, 4, 4, 1, 8, 9, 9, 1, 7], 100))
# 69317163492948606335995924319873 becomes 52432133.
  puts(first_eight_digits([6, 9, 3, 1, 7, 1, 6, 3, 4, 9, 2, 9, 4, 8, 6, 0, 6, 3, 3, 5, 9, 9, 5, 9, 2, 4, 3, 1, 9, 8, 7, 3], 100))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  input = get_numbers_from_file("day16_input.txt")
  puts(first_eight_digits(input, 100))
end


def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
# 03036732577212944063491565474664 becomes 84462026.
  puts(real_signal([0, 3, 0, 3, 6, 7, 3, 2, 5, 7, 7, 2, 1, 2, 9, 4, 4, 0, 6, 3, 4, 9, 1, 5, 6, 5, 4, 7, 4, 6, 6, 4], 100))
# 02935109699940807407585447034323 becomes 78725270.
  puts(real_signal([0, 2, 9, 3, 5, 1, 0, 9, 6, 9, 9, 9, 4, 0, 8, 0, 7, 4, 0, 7, 5, 8, 5, 4, 4, 7, 0, 3, 4, 3, 2, 3], 100))
# 03081770884921959731165446850517 becomes 53553731.
  puts(real_signal([0, 3, 0, 8, 1, 7, 7, 0, 8, 8, 4, 9, 2, 1, 9, 5, 9, 7, 3, 1, 1, 6, 5, 4, 4, 6, 8, 5, 0, 5, 1, 7], 100))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  input = get_numbers_from_file("day16_input.txt")
  puts(real_signal(input, 100))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()
