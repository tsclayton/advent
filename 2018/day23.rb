#!/usr/bin/env ruby

class Instruction
  attr_accessor :operation
  attr_accessor :lhs
  attr_accessor :rhs

  def initialize(operation, lhs, rhs)
    @operation = operation
    @lhs = lhs
    @rhs = rhs
  end

  def get_value(sym, registers)
    if sym != nil
      if is_register?(sym)
        registers[sym] ||= 0
        return registers[sym] || 0
      else
        return sym.to_i
      end
    end

    nil
  end

  def get_lhs(registers)
    get_value(@lhs, registers)
  end

  def get_rhs(registers)
    get_value(@rhs, registers)
  end
end

def is_register?(sym)
  sym.match(/[A-z]/) != nil
end

def parse_file(filename)
  instructions = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      parsed_line = line.split(' ')
      instructions << Instruction.new(parsed_line[0], parsed_line[1], parsed_line[2])
    end

  end

  instructions
end

def run_instructions(instructions, registers = {})
  curr_index = 0
  num_muls = 0

  while true
    break if curr_index >= instructions.length
    curr_instruction = instructions[curr_index]

    registers[curr_instruction.lhs] ||= 0 if is_register?(curr_instruction.lhs)

    rhs = curr_instruction.get_rhs(registers)

    case curr_instruction.operation
    when 'set'
      registers[curr_instruction.lhs] = rhs
    when 'sub'
      registers[curr_instruction.lhs] -= rhs
    when 'mul'
      num_muls += 1
      registers[curr_instruction.lhs] *= rhs
    when 'mod'
      registers[curr_instruction.lhs] %= rhs
    when 'jnz'
      curr_index += rhs - 1 if curr_instruction.get_lhs(registers) != 0
    end

    curr_index += 1
  end

  {num_muls: num_muls, value_of_h: registers['h']}
end

def part_1
  puts("INPUT SOLUTION:")
  file_input = parse_file("day23_input.txt")
  puts(run_instructions(file_input)[:num_muls])
end

def optimized_input_program()
  non_primes = 0

  lower_bound = 109300
  upper_bound = 126300

  while lower_bound <= upper_bound
    for factor_one in 2..(lower_bound / 2)
      if (lower_bound % factor_one == 0)
        non_primes += 1
        break
      end
    end

    lower_bound += 17
  end

  non_primes
end

def part_2
  puts("INPUT SOLUTION:")
  puts(optimized_input_program())
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
