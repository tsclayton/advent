#!/usr/bin/env ruby

class Recipe
  attr_accessor :ingredients
  attr_accessor :product
  attr_accessor :quantity

  def initialize(ingredients, product, quantity)
    @ingredients = ingredients
    @product = product
    @quantity = quantity
  end
end

def get_recipe_from_string(str)
  split_str = str.split(' => ')
  ingredients_portion = split_str[0]
  product_portion = split_str[1]

  split_product = product_portion.split(' ')
  quantity = split_product[0].to_i
  product = split_product[1]

  ingredients_list = ingredients_portion.split(', ')
  ingredients = {}

  ingredients_list.each do |ingredient_listing|
    split_ingredient = ingredient_listing.split(' ')
    ingredients[split_ingredient[1]] = split_ingredient[0].to_i
  end

  Recipe.new(ingredients, product, quantity)
end

def get_recipes_from_file(filename)
  recipes = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      recipes << get_recipe_from_string(line)
    end
  end

  recipes
end

def get_ingredients_for_fuel(ingredient, fuel_quantity, recipes)
  return fuel_quantity if ingredient == 'FUEL'

  total_ingredients = 0

  recipes.each do |recipe|
    if !recipe.ingredients[ingredient].nil?
      total_ingredients += recipe.ingredients[ingredient] * (get_ingredients_for_fuel(recipe.product, fuel_quantity, recipes).to_f / recipe.quantity).ceil
    end
  end

  total_ingredients
end

def get_number_of_ore_for_fuel(recipes, fuel_quantity)
  get_ingredients_for_fuel('ORE', fuel_quantity, recipes)
end

def fuel_produced_with_ore(recipes, ore_quantity)
  ore_for_one_fuel = get_number_of_ore_for_fuel(recipes, 1)
  lower_bound = ore_quantity / ore_for_one_fuel

  upper_bound = lower_bound

  while true
    upper_bound *= 10
    ore_needed = get_number_of_ore_for_fuel(recipes, upper_bound)
    break if ore_needed > ore_quantity
  end

  while true
    midpoint = lower_bound + ((upper_bound - lower_bound) / 2)
    ore_needed = get_number_of_ore_for_fuel(recipes, midpoint)

    if ore_needed == ore_quantity || upper_bound - lower_bound <= 1
      return midpoint
    elsif ore_needed < ore_quantity
      lower_bound = midpoint
    else
      upper_bound = midpoint
    end
  end
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  recipes = [
    '10 ORE => 10 A',
    '1 ORE => 1 B',
    '7 A, 1 B => 1 C',
    '7 A, 1 C => 1 D',
    '7 A, 1 D => 1 E',
    '7 A, 1 E => 1 FUEL'].map{|r| get_recipe_from_string(r)}
  puts(get_number_of_ore_for_fuel(recipes, 1))

  recipes = [
    '9 ORE => 2 A',
    '8 ORE => 3 B',
    '7 ORE => 5 C',
    '3 A, 4 B => 1 AB',
    '5 B, 7 C => 1 BC',
    '4 C, 1 A => 1 CA',
    '2 AB, 3 BC, 4 CA => 1 FUEL'].map{|r| get_recipe_from_string(r)}
  puts(get_number_of_ore_for_fuel(recipes, 1))

  recipes = [
    '157 ORE => 5 NZVS',
    '165 ORE => 6 DCFZ',
    '44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL',
    '12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ',
    '179 ORE => 7 PSHF',
    '177 ORE => 5 HKGWZ',
    '7 DCFZ, 7 PSHF => 2 XJWVT',
    '165 ORE => 2 GPVTF',
    '3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT'].map{|r| get_recipe_from_string(r)}
  puts(get_number_of_ore_for_fuel(recipes, 1))

  recipes = [
    '2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG',
    '17 NVRVD, 3 JNWZP => 8 VPVL',
    '53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL',
    '22 VJHF, 37 MNCFX => 5 FWMGM',
    '139 ORE => 4 NVRVD',
    '144 ORE => 7 JNWZP',
    '5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC',
    '5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV',
    '145 ORE => 6 MNCFX',
    '1 NVRVD => 8 CXFTF',
    '1 VJHF, 6 MNCFX => 4 RFSQX',
    '176 ORE => 6 VJHF'].map{|r| get_recipe_from_string(r)}
  puts(get_number_of_ore_for_fuel(recipes, 1))

  recipes = [
    '171 ORE => 8 CNZTR',
    '7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL',
    '114 ORE => 4 BHXH',
    '14 VRPVC => 6 BMBT',
    '6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL',
    '6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT',
    '15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW',
    '13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW',
    '5 BMBT => 4 WPTQ',
    '189 ORE => 9 KTJDG',
    '1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP',
    '12 VRPVC, 27 CNZTR => 2 XDBXC',
    '15 KTJDG, 12 BHXH => 5 XCVML',
    '3 BHXH, 2 VRPVC => 7 MZWV',
    '121 ORE => 7 VRPVC',
    '7 XCVML => 6 RJRHP',
    '5 BHXH, 4 VRPVC => 5 LTCX'].map{|r| get_recipe_from_string(r)}
  puts(get_number_of_ore_for_fuel(recipes, 1))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  recipes = get_recipes_from_file("day14_input.txt")
  puts(get_number_of_ore_for_fuel(recipes, 1))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  recipes = [
    '157 ORE => 5 NZVS',
    '165 ORE => 6 DCFZ',
    '44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL',
    '12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ',
    '179 ORE => 7 PSHF',
    '177 ORE => 5 HKGWZ',
    '7 DCFZ, 7 PSHF => 2 XJWVT',
    '165 ORE => 2 GPVTF',
    '3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT'].map{|r| get_recipe_from_string(r)}
  puts(fuel_produced_with_ore(recipes, 1_000_000_000_000))

  recipes = [
    '2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG',
    '17 NVRVD, 3 JNWZP => 8 VPVL',
    '53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL',
    '22 VJHF, 37 MNCFX => 5 FWMGM',
    '139 ORE => 4 NVRVD',
    '144 ORE => 7 JNWZP',
    '5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC',
    '5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV',
    '145 ORE => 6 MNCFX',
    '1 NVRVD => 8 CXFTF',
    '1 VJHF, 6 MNCFX => 4 RFSQX',
    '176 ORE => 6 VJHF'].map{|r| get_recipe_from_string(r)}
  puts(fuel_produced_with_ore(recipes, 1_000_000_000_000))

  recipes = [
    '171 ORE => 8 CNZTR',
    '7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL',
    '114 ORE => 4 BHXH',
    '14 VRPVC => 6 BMBT',
    '6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL',
    '6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT',
    '15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW',
    '13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW',
    '5 BMBT => 4 WPTQ',
    '189 ORE => 9 KTJDG',
    '1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP',
    '12 VRPVC, 27 CNZTR => 2 XDBXC',
    '15 KTJDG, 12 BHXH => 5 XCVML',
    '3 BHXH, 2 VRPVC => 7 MZWV',
    '121 ORE => 7 VRPVC',
    '7 XCVML => 6 RJRHP',
    '5 BHXH, 4 VRPVC => 5 LTCX'].map{|r| get_recipe_from_string(r)}
  puts(fuel_produced_with_ore(recipes, 1_000_000_000_000))

end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  recipes = get_recipes_from_file("day14_input.txt")
  puts(fuel_produced_with_ore(recipes, 1_000_000_000_000))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()