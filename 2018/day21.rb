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

def run_program(instructions, ip_reg, part_2 = false)
  registers = [0, 0, 0, 0, 0, 0]
  results = {}
  prev_result = 0

  while registers[ip_reg] < instructions.length
    if registers[ip_reg] == 28
      return registers[3] if !part_2
      return prev_result if !results[registers[3]].nil?
      prev_result = registers[3]
      results[registers[3]] = true
    end

    instruction = instructions[registers[ip_reg]]
    registers = run_instruction(instruction, registers)
    registers[ip_reg] += 1
  end

  -1
end

# Completes part 2 a lot faster
def run_ruby_program(part_2 = false)
  #ip 5
  r1 = r2 = r3 = r4 = 0
  results = {}
  prev_result = 0

  while true
    r1 = r3 | 65536
    r3 = 14906355

    while true
      r4 = r1 & 255
      r3 = r3 + r4
      r3 = r3 & 16777215
      r3 = r3 * 65899
      r3 = r3 & 16777215

      break if 256 > r1

      r4 = 0

      while true
        r2 = r4 + 1
        r2 *= 256

        break if r2 > r1

        r4 += 1
      end

      r1 = r4
    end

    return r3 if !part_2
    return prev_result if !results[r3].nil?
    prev_result = r3
    results[r3] = true
  end
end

def part_1_final()
  puts("PART 1 FINAL SOLUTION:")
  program = get_program_from_file('day21_input.txt')
  puts(run_program(program[:instructions], program[:ip_reg]))
end

def part_2_final()
  puts("PART 2 FINAL SOLUTION:")
  program = get_program_from_file('day21_input.txt')
  puts(run_ruby_program(true))
end

part_1_final()
part_2_final()