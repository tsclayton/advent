#!/usr/bin/env ruby

def get_input_from_file(filename)
  rules = {}
  messages = []

  File.read(filename).split("\n").each do |line|
    if !line.match(/:/).nil?
      split_line = line.split(': ')
      rule_num = split_line[0].to_i

      if split_line[1].match(/"/)
        rules[rule_num] = split_line[1].gsub(/"/, '')
      else
        sub_rule_strs = split_line[1].split('|')
        sub_rules = []

        sub_rule_strs.each do |sub_rule_str|
          sub_rules << sub_rule_str.scan(/[0-9]+/).map(&:to_i)
        end

        rules[rule_num] = sub_rules
      end
    elsif line.length > 0
      messages << line
    end
  end

  {rules: rules, messages: messages}
end

def get_regexp(rules, rule_num, recursive_rules = false, cache = {})
  rule = rules[rule_num]

  return rule if rule.is_a?(String)

  return cache[rule_num] if !cache[rule_num].nil?

  if recursive_rules
    if rule_num == 8  
      exp = "((#{get_regexp(rules, 42, recursive_rules, cache)})+)"
      cache[rule_num] = exp
      return exp
    elsif rule_num == 11
      # TIL about recursive regexs
      exp = "(?<r>#{get_regexp(rules, 42, recursive_rules, cache)}\\g<r>?#{get_regexp(rules, 31, recursive_rules, cache)})"
      cache[rule_num] = exp
      return exp
    end
  end

  sub_exprs = []

  for i in 0...rule.length
    sub_expr = ''
    for j in 0...rule[i].length
      sub_expr += get_regexp(rules, rule[i][j], recursive_rules, cache)
    end

    sub_exprs << sub_expr
  end

  exp = sub_exprs.join('|')
  exp = '(' + exp + ')' if rule.length > 0

  cache[rule_num] = exp
  exp
end

def num_matching_messages(rules, messages, recursive_rules = false)
  matching_messages = 0

  regexp = "^#{get_regexp(rules, 0, recursive_rules)}$"
  messages.each do |message|
    matching_messages += 1 if !message.match(regexp).nil?
  end

  matching_messages
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTIONS:')
  rules = {
    0 => [[4, 1, 5]],
    1 => [[2, 3], [3, 2]],
    2 => [[4, 4], [5, 5]],
    3 => [[4, 5], [5, 4]],
    4 => 'a',
    5 => 'b'
  }
  messages = [
    'ababbb',
    'bababa',
    'abbbab',
    'aaabbb',
    'aaaabbb',
  ]
  puts(num_matching_messages(rules, messages))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  input = get_input_from_file('day19_input.txt')
  puts(num_matching_messages(input[:rules], input[:messages]))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  input = get_input_from_file('day19_example.txt')
  puts(num_matching_messages(input[:rules], input[:messages], true))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  input = get_input_from_file('day19_input.txt')
  puts(num_matching_messages(input[:rules], input[:messages], true))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()