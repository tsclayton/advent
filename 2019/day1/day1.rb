#!/usr/bin/env ruby

def parse_file_to_ints(filename)
  nums = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      nums << line.gsub(/[\s+]+/, '').to_i
    end
  end

  nums
end

def fuel_requirements(mass)
  ((mass / 3.0).floor) - 2
end

def fuel_requirements_sum(masses)
  masses.map {|mass| fuel_requirements(mass)}.reduce(:+)
end

def recursive_fuel_requirements(mass)
  total_fuel = 0

  while true
    fuel_mass = fuel_requirements(mass)
    break if fuel_mass <= 0
    total_fuel += fuel_mass
    mass = fuel_mass
  end

  total_fuel
end

def recursive_fuel_requirements_sum(masses)
  masses.map {|mass| recursive_fuel_requirements(mass)}.reduce(:+)
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  puts(fuel_requirements(12))
  puts(fuel_requirements(14))
  puts(fuel_requirements(1969))
  puts(fuel_requirements(100756))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  file_input = parse_file_to_ints("day1_input.txt")
  puts(fuel_requirements_sum(file_input))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  puts(recursive_fuel_requirements(14))
  puts(recursive_fuel_requirements(1969))
  puts(recursive_fuel_requirements(100756))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  file_input = parse_file_to_ints("day1_input.txt")
  puts(recursive_fuel_requirements_sum(file_input))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()
