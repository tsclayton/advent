#!/usr/bin/env ruby

def get_numbers_from_file(filename)
  nums = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      nums << line.gsub(/[\s+]+/, '').to_i
    end
  end

  nums
end

def get_2020_sum(numbers)
  for i in 0...(numbers.length - 1)
    for j in (i + 1)...numbers.length
      return [numbers[i], numbers[j]] if numbers[i] + numbers[j] == 2020
    end
  end

  []
end

def get_2020_sum_product(numbers)
  sum = get_2020_sum(numbers)
  sum[0] * sum[1]
end


def get_2020_tri_sum(numbers)
  for i in 0...(numbers.length - 2)
    for j in (i + 1)...(numbers.length - 1)
      for k in (i + 2)...numbers.length
        return [numbers[i], numbers[j], numbers[k]] if numbers[i] + numbers[j] + numbers[k] == 2020
      end
    end
  end

  []
end

def get_2020_tri_sum_product(numbers)
  sum = get_2020_tri_sum(numbers)
  puts sum
  sum[0] * sum[1] * sum[2]
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  puts(get_2020_sum_product([1721, 979, 366, 299, 675, 1456]))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  numbers = get_numbers_from_file("day1_input.txt")
  puts(get_2020_sum_product(numbers))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  puts(get_2020_tri_sum_product([1721, 979, 366, 299, 675, 1456]))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  numbers = get_numbers_from_file("day1_input.txt")
  puts(get_2020_tri_sum_product(numbers))
end

part_1_example()
part_1_final()
part_2_examples()
part_2_final()
