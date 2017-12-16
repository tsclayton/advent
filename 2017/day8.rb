#!/usr/bin/env ruby

def parse_file(filename)
  instructions = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      parsed_line = line.gsub(/\s+/, ' ').split(' ')

      register = parsed_line.shift
      operation = parsed_line.shift
      value = parsed_line.shift.to_i

      condition = {}
      # shift useless "if"
      parsed_line.shift
      condition[:register] = parsed_line.shift
      condition[:predicate] = parsed_line.shift
      condition[:value] = parsed_line.shift.to_i

      instructions << {register: register, operation: operation, value: value, condition: condition}
    end
  end

  instructions
end

def evaluate_condition(condition, registers)
  # puts condition[:predicate]
  case condition[:predicate]
    when '<'
      registers[condition[:register]] < condition[:value]
    when '<='
      registers[condition[:register]] <= condition[:value]
    when '=='
      registers[condition[:register]] == condition[:value]
    when '!='
      registers[condition[:register]] != condition[:value]
    when '>='
      registers[condition[:register]] >= condition[:value]
    when '>'
      registers[condition[:register]] > condition[:value]
    else
      false
    end
end

def run_instructions(instructions, registers)
  max_value = 0

  instructions.each do |instruction|
    # initialize registers if we have to
    registers[instruction[:register]] ||= 0
    registers[instruction[:condition][:register]] ||= 0

    if evaluate_condition(instruction[:condition], registers)
      if instruction[:operation] == 'inc'
        registers[instruction[:register]] += instruction[:value]
      elsif instruction[:operation] == 'dec'
        registers[instruction[:register]] -= instruction[:value]
      end

      max_value = [max_value, registers[instruction[:register]]].max
    end
  end

  max_value
end

def largest_register_value(instructions)
  registers = {}
  run_instructions(instructions, registers)
  registers.max_by {|register, value| value}[1]
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = parse_file("day8_example.txt")
  puts(largest_register_value(example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day8_input.txt")
  puts(largest_register_value(file_input))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  example_input = parse_file("day8_example.txt")
  puts(run_instructions(example_input, {}))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day8_input.txt")
  puts(run_instructions(file_input, {}))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
