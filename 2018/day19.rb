#!/usr/bin/env ruby

class Instruction
  attr_accessor :operator
  attr_accessor :input_a
  attr_accessor :input_b
  attr_accessor :output_reg

  def initialize(operator, input_a, input_b, output_reg)
    @operator = operator
    @input_a = input_a
    @input_b = input_b
    @output_reg = output_reg
  end

  def str()
    "#{@operator} #{@input_a} #{@input_b} #{@output_reg}"
  end
end

def get_program_from_file(filename)
  instructions = []
  ip_reg = 0

  File.read(filename).split("\n").each do |line|
    if !line.match(/#ip/).nil?
      ip_reg = line.match(/[0-9]+/).to_s.to_i
      next
    end

    operator = line.match(/[a-z]+/).to_s
    numbers = line.scan(/-*[0-9]+/).map(&:to_i)
    instructions << Instruction.new(operator, numbers[0], numbers[1], numbers[2])
  end

  {instructions: instructions, ip_reg: ip_reg}
end

def run_instruction(instruction, registers)
  case instruction.operator
    when 'addr'
      registers[instruction.output_reg] = registers[instruction.input_a] + registers[instruction.input_b]
    when 'addi'
      registers[instruction.output_reg] = registers[instruction.input_a] + instruction.input_b
    when 'mulr'
      registers[instruction.output_reg] = registers[instruction.input_a] * registers[instruction.input_b]
    when 'muli'
      registers[instruction.output_reg] = registers[instruction.input_a] * instruction.input_b
    when 'banr'
      registers[instruction.output_reg] = registers[instruction.input_a] & registers[instruction.input_b]
    when 'bani'
      registers[instruction.output_reg] = registers[instruction.input_a] & instruction.input_b
    when 'borr'
      registers[instruction.output_reg] = registers[instruction.input_a] | registers[instruction.input_b]
    when 'bori'
      registers[instruction.output_reg] = registers[instruction.input_a] | instruction.input_b
    when 'setr'
      registers[instruction.output_reg] = registers[instruction.input_a]
    when 'seti'
      registers[instruction.output_reg] = instruction.input_a
    when 'gtir'
      registers[instruction.output_reg] = instruction.input_a > registers[instruction.input_b] ? 1 : 0
    when 'gtri'
      registers[instruction.output_reg] = registers[instruction.input_a] > instruction.input_b ? 1 : 0
    when 'gtrr'
      registers[instruction.output_reg] = registers[instruction.input_a] > registers[instruction.input_b] ? 1 : 0
    when 'eqir'
      registers[instruction.output_reg] = instruction.input_a == registers[instruction.input_b] ? 1 : 0
    when 'eqri'
      registers[instruction.output_reg] = registers[instruction.input_a] == instruction.input_b ? 1 : 0
    when 'eqrr'
      registers[instruction.output_reg] = registers[instruction.input_a] == registers[instruction.input_b] ? 1 : 0
    else
      puts "this shouldn't happen. operator = #{operator}"
  end

  registers
end

def run_program(instructions, ip_reg)
  registers = [0, 0, 0, 0, 0, 0]

  while registers[ip_reg] < instructions.length
    instruction = instructions[registers[ip_reg]]
    registers = run_instruction(instruction, registers)
    registers[ip_reg] += 1
  end

  registers[0]
end

def factor_sum(value)
  sum = value + 1

  for i in 2..(value / 2)
    sum += i if value % i == 0
  end

  sum
end

def part_1_example()
  puts("PART 1 EXAMPLE SOLUTION:")
  instructions = [
    Instruction.new('seti', 5, 0, 1),
    Instruction.new('seti', 6, 0, 2),
    Instruction.new('addi', 0, 1, 0),
    Instruction.new('addr', 1, 2, 3),
    Instruction.new('setr', 1, 0, 0),
    Instruction.new('seti', 8, 0, 4),
    Instruction.new('seti', 9, 0, 5)
  ]
  puts(run_program(instructions, 0))
end

def part_1_final()
  puts("PART 1 FINAL SOLUTION:")
  program = get_program_from_file('day19_input.txt')
  puts(run_program(program[:instructions], program[:ip_reg]))
end

def part_2_final()
  puts("PART 2 FINAL SOLUTION:")
  puts(factor_sum(929))
  puts(factor_sum(10551329))
end

part_1_example()
part_1_final()
part_2_final()
