#!/usr/bin/env ruby

def get_rule_strings_from_file(filename)
  rule_strings = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      rule_strings << line.chomp
    end
  end

  rule_strings
end

def compile_rules_from_strings(rule_strings)
  rules = {}

  rule_strings.each do |rule_string|
    contents = {}
    split_string = rule_string.chomp('.').split(' contain ')
    bag = split_string[0].chomp('s')
    content_strings = split_string[1].split(', ')
    content_strings.each do |content_string|
      number_required = content_string.match(/[0-9]+/).to_s.to_i
      content = content_string.match(/[a-z][a-z ]+[^s]/).to_s
      next if number_required == 0
      contents[content] = number_required
    end

    rules[bag] = contents
  end

  rules
end

def bags_containing_bag(rules, bag)
  bags = []

  rules.each do |containing_bag, contents|
    if !contents[bag].nil?
      # puts "#{containing_bag} contains #{bag}"
      bags += [containing_bag] + bags_containing_bag(rules, containing_bag)
    end
  end

  bags.uniq
end

def num_bags_containing_bag(rule_strings, bag)
  rules = compile_rules_from_strings(rule_strings)
  bags_containing_bag(rules, bag).length
end

def bags_within_bag(rules, bag)
  total_bags = 1

  rules[bag].each do |lil_bag, quantity|
    total_bags += (quantity * bags_within_bag(rules, lil_bag))
  end

  total_bags
end

def num_bags_within_bag(rule_strings, bag)
  rules = compile_rules_from_strings(rule_strings)
  # subtract 1 to exclude the bag in question
  bags_within_bag(rules, bag) - 1
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  rule_strings = [
    'light red bags contain 1 bright white bag, 2 muted yellow bags.',
    'dark orange bags contain 3 bright white bags, 4 muted yellow bags.',
    'bright white bags contain 1 shiny gold bag.',
    'muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.',
    'shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.',
    'dark olive bags contain 3 faded blue bags, 4 dotted black bags.',
    'vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.',
    'faded blue bags contain no other bags.',
    'dotted black bags contain no other bags.'
  ]

  puts(num_bags_containing_bag(rule_strings, 'shiny gold bag'))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  rule_strings = get_rule_strings_from_file("day7_input.txt")
  puts(num_bags_containing_bag(rule_strings, 'shiny gold bag'))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  rule_strings = [
    'light red bags contain 1 bright white bag, 2 muted yellow bags.',
    'dark orange bags contain 3 bright white bags, 4 muted yellow bags.',
    'bright white bags contain 1 shiny gold bag.',
    'muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.',
    'shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.',
    'dark olive bags contain 3 faded blue bags, 4 dotted black bags.',
    'vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.',
    'faded blue bags contain no other bags.',
    'dotted black bags contain no other bags.'
  ]
  puts(num_bags_within_bag(rule_strings, 'shiny gold bag'))

  rule_strings = [
    'shiny gold bags contain 2 dark red bags.',
    'dark red bags contain 2 dark orange bags.',
    'dark orange bags contain 2 dark yellow bags.',
    'dark yellow bags contain 2 dark green bags.',
    'dark green bags contain 2 dark blue bags.',
    'dark blue bags contain 2 dark violet bags.',
    'dark violet bags contain no other bags.'
  ]
  puts(num_bags_within_bag(rule_strings, 'shiny gold bag'))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  rule_strings = get_rule_strings_from_file("day7_input.txt")
  puts(num_bags_within_bag(rule_strings, 'shiny gold bag'))
end

part_1_example()
part_1_final()
part_2_examples()
part_2_final()