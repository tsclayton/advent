#!/usr/bin/env ruby

def get_foods_from_strings(strings)
  foods = {}

  strings.each do |string|
    split_string = string.split(' (contains ')
    ingredients = split_string[0].split(' ')
    split_string[1][-1] = ''
    allergens = split_string[1].split(', ')
    foods[ingredients] = allergens
  end

  foods
end

def get_foods_from_file(filename)
  get_foods_from_strings(File.read(filename).split("\n"))
end

def get_possible_allergens(foods)
  allergen_to_foods = {}
  all_ingredients = []

  foods.each do |ingredients, allergens|
    ingredients.each do |ingredient|
      all_ingredients << ingredient if !all_ingredients.member?(ingredient)
    end

    allergens.each do |allergen|
      allergen_to_foods[allergen] ||= []
      allergen_to_foods[allergen] << ingredients
    end
  end

  possible_allergens = {}

  all_ingredients.each do |ingredient|
    possible_allergens[ingredient] ||= []

    allergen_to_foods.each do |allergen, foods|
      is_in_all_foods = true

      foods.each do |ingredients|
        if !ingredients.member?(ingredient)
          is_in_all_foods = false
          break
        end
      end

      if is_in_all_foods
        possible_allergens[ingredient] << allergen
      end
    end
  end

  possible_allergens
end

def non_allergen_count(foods)
  possible_allergens = get_possible_allergens(foods)
  non_allergen_ingredients = []

  possible_allergens.each do |ingredient, possible_allergens|
    non_allergen_ingredients << ingredient if possible_allergens.empty?
  end

  foods.keys.map {|ingredients| ingredients.length - (ingredients - non_allergen_ingredients).length}.sum
end

def assign_allergens(possible_allergens)
  allergen_ingredients = {}
  possible_allergens.delete_if {|ingredient, possible_allergens| possible_allergens.empty?}
  total_allergens = possible_allergens.length

  # Should be assigning 1 allergen per iteration
  for i in 0...total_allergens
    assigned_allergen = nil
    possible_allergens.each do |ingredient, possible_allergens|
      if possible_allergens.length == 1
        assigned_allergen = possible_allergens[0]
        allergen_ingredients[assigned_allergen] = ingredient
        break
      end
    end

    possible_allergens.keys.each do |ingredient|
      possible_allergens[ingredient] = possible_allergens[ingredient] - [assigned_allergen]
      possible_allergens.delete(ingredient) if possible_allergens[ingredient].length == 0
    end
  end

  allergen_ingredients
end

def canonical_dangerous_ingredients(foods)
  possible_allergens = get_possible_allergens(foods)
  allergen_ingredients = assign_allergens(possible_allergens)

  allergen_ingredients.keys.sort.map {|allergen| allergen_ingredients[allergen]}.join(',')
end

def part_1_examples
  puts('PART 1 EXAMPLE SOLUTIONS:')
  foods = get_foods_from_strings([
    'mxmxvkd kfcds sqjhc nhms (contains dairy, fish)',
    'trh fvjkl sbzzf mxmxvkd (contains dairy)',
    'sqjhc fvjkl (contains soy)',
    'sqjhc mxmxvkd sbzzf (contains fish)',
  ])
  puts(non_allergen_count(foods))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  foods = get_foods_from_file('day21_input.txt')
  puts(non_allergen_count(foods))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  foods = get_foods_from_strings([
    'mxmxvkd kfcds sqjhc nhms (contains dairy, fish)',
    'trh fvjkl sbzzf mxmxvkd (contains dairy)',
    'sqjhc fvjkl (contains soy)',
    'sqjhc mxmxvkd sbzzf (contains fish)',
  ])
  puts(canonical_dangerous_ingredients(foods))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  foods = get_foods_from_file('day21_input.txt')
  puts(canonical_dangerous_ingredients(foods))
end

part_1_examples()
part_1_final()
part_2_example()
part_2_final()