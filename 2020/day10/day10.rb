#!/usr/bin/env ruby

def get_joltage_ratings_from_file(filename)
  joltages = File.read(filename).split("\n").map(&:to_i)
end

def device_adaptor_rating(joltage_ratings)
  joltage_ratings.max + 3
end

def get_sorted_chain(joltage_ratings)
  ([0] + joltage_ratings + [device_adaptor_rating(joltage_ratings)]).sort
end

def difference_product(joltage_ratings)
  one_differences = 0
  three_differences = 0

  daisy_chain = get_sorted_chain(joltage_ratings)

  for i in 1...daisy_chain.length
    one_differences += 1 if daisy_chain[i] - daisy_chain[i - 1] == 1
    three_differences += 1 if daisy_chain[i] - daisy_chain[i - 1] == 3
  end

  one_differences * three_differences
end

# Knew there was a mathy solution, but had to check online for specifics
def total_combinations(joltage_ratings)
  daisy_chain = get_sorted_chain(joltage_ratings)

  combinations = 1

  current_group_length = 0

  for i in 0...(daisy_chain.length - 1)
    if daisy_chain[i + 1] - daisy_chain[i] == 1
      current_group_length += 1
    elsif daisy_chain[i + 1] - daisy_chain[i] == 3
      case current_group_length
      when 4
        # eg. 3, 6, 7, 8, 9, 10, 13: 789, 78, 79, 7, 89, 8, 9
        combinations *= 7
      when 3
        # eg. 3, 6, 7, 8, 9, 12: 78, 7, 8, blank
        combinations *= 4
      when 2
        # eg. 3, 6, 7, 8, 11: either 7 is there or it isn't
        combinations *= 2
      end

      current_group_length = 0
    end
  end

  combinations
end

def part_1_examples
  puts('PART 1 EXAMPLE SOLUTIONS:')
  joltage_ratings = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
  puts(difference_product(joltage_ratings))

  joltage_ratings = [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3]
  puts(difference_product(joltage_ratings))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  joltage_ratings = get_joltage_ratings_from_file('day10_input.txt')
  puts(difference_product(joltage_ratings))
end

def part_2_examples
  puts('PART 2 EXAMPLE SOLUTIONS:') 
  joltage_ratings = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
  puts(total_combinations(joltage_ratings))

  # 19208 =  2 * 2  * 3 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 3 
  joltage_ratings = [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3]
  puts(total_combinations(joltage_ratings))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  joltage_ratings = get_joltage_ratings_from_file('day10_input.txt')
  puts(total_combinations(joltage_ratings))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()