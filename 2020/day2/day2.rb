#!/usr/bin/env ruby

def get_policy_from_string(str)
  split_str = str.split(' ')
  char = split_str[1][0]

  min_max = split_str[0].split('-').map(&:to_i)
  {min: min_max[0], max: min_max[1], char: char, password: split_str[2]}
end

def get_policies_from_file(filename)
  policies = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      policies << get_policy_from_string(line)
    end
  end

  policies
end

def validate_old_policies(policies)
  valid_passwords = 0

  policies.each do |policy|
    char_count = 0

    for i in 0...policy[:password].length
      char_count += 1 if policy[:password][i] == policy[:char]
    end

    valid_passwords += 1 if char_count >= policy[:min] && char_count <= policy[:max]
  end

  valid_passwords
end

def validate_new_policies(policies)
  valid_passwords = 0

  policies.each do |policy|
    valid_passwords += 1 if policy[:password][policy[:min] - 1] !=  policy[:password][policy[:max] - 1] && 
      (policy[:password][policy[:min] - 1] == policy[:char] || policy[:password][policy[:max] - 1] == policy[:char])
  end

  valid_passwords
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  puts(validate_old_policies([
    '1-3 a: abcde',
    '1-3 b: cdefg',
    '2-9 c: ccccccccc'].map {|str| get_policy_from_string(str)}))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  puts(validate_old_policies(get_policies_from_file("day2_input.txt")))
end

def part_2_example
  puts("PART 2 EXAMPLE SOLUTION:")
  puts(validate_new_policies([
    '1-3 a: abcde',
    '1-3 b: cdefg',
    '2-9 c: ccccccccc'].map {|str| get_policy_from_string(str)}))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  puts(validate_new_policies(get_policies_from_file("day2_input.txt")))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()
