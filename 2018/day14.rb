#!/usr/bin/env ruby

def get_next_ten_recipes(num_initial_recipes)
  recipes = [3, 7]
  final_recipes = []

  elf_1_index = 0
  elf_2_index = 1

  while recipes.length < (num_initial_recipes + 10)
    recipe_sum = recipes[elf_1_index] + recipes[elf_2_index]
    recipe_sum_string = recipe_sum.to_s

    for j in 0...recipe_sum_string.length
      new_recipe = recipe_sum_string[j].to_i
      recipes << new_recipe

      break if recipes.length >= (num_initial_recipes + 10)
    end

    elf_1_index = (elf_1_index + recipes[elf_1_index] + 1) % recipes.length
    elf_2_index = (elf_2_index + recipes[elf_2_index] + 1) % recipes.length
  end

  recipes[(recipes.length - 10)...recipes.length].join('')
end

def get_num_recipes_before_match(recipe_sequence)
  recipes = [3, 7]
  final_recipes = []

  elf_1_index = 0
  elf_2_index = 1

  sequence_string = recipe_sequence.to_s
  starting_match_index = 0
  current_match_index = 0

  while current_match_index < sequence_string.length
    recipe_sum = recipes[elf_1_index] + recipes[elf_2_index]
    recipe_sum_string = recipe_sum.to_s

    for j in 0...recipe_sum_string.length
      new_recipe = recipe_sum_string[j].to_i
      recipes << new_recipe

      if sequence_string[current_match_index].to_i == new_recipe
        current_match_index += 1
      else
        current_match_index = 0
      end

      break if current_match_index >= sequence_string.length
    end

    elf_1_index = (elf_1_index + recipes[elf_1_index] + 1) % recipes.length
    elf_2_index = (elf_2_index + recipes[elf_2_index] + 1) % recipes.length
  end

  recipes.length - sequence_string.length
end

def part_1
  puts("EXAMPLE SOLUTION:")
  puts(get_next_ten_recipes(9))
  puts(get_next_ten_recipes(5))
  puts(get_next_ten_recipes(18))
  puts(get_next_ten_recipes(2018))

  puts("INPUT SOLUTION:")
  puts(get_next_ten_recipes(768071))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  puts(get_num_recipes_before_match(51589))
  # 9
  puts(get_num_recipes_before_match(01245))
  # 5
  puts(get_num_recipes_before_match(92510))
  # 18
  puts(get_num_recipes_before_match(59414))
  # 2018

  puts("INPUT SOLUTION:")
  puts(get_num_recipes_before_match(768071))
  # 20198090
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
