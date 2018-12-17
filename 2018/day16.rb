#!/usr/bin/env ruby

class Instruction
  attr_accessor :opcode
  attr_accessor :input_a
  attr_accessor :input_b
  attr_accessor :output_reg

  def initialize(opcode, input_a, input_b, output_reg)
    @opcode = opcode
    @input_a = input_a
    @input_b = input_b
    @output_reg = output_reg
  end
end

class Sample
  attr_accessor :instruction
  attr_accessor :registers_before
  attr_accessor :registers_after

  attr_accessor :operator_candidates

  def initialize(instruction, registers_before, registers_after)
    @instruction = instruction
    @registers_before = registers_before
    @registers_after = registers_after

    @operator_candidates = []
  end
end

def get_program_and_samples_from_file(filename)
  instructions = []
  samples = []

  File.open(filename, "r") do |file|
    current_sample = []

    file.each_line do |line|
      next if line.nil? || line.length == 0

      numbers = line.scan(/-*[0-9]+/).map(&:to_i)

      if line[0] == 'B'
        current_sample << numbers
      elsif line[0] == 'A'
        # puts ""
        samples << Sample.new(current_sample[1], current_sample[0], numbers)
        current_sample = []
      elsif line[0].match(/[0-9]/)
        if current_sample.length > 0
          current_sample << Instruction.new(numbers[0], numbers[1], numbers[2], numbers[3])
        else
          instructions << Instruction.new(numbers[0], numbers[1], numbers[2], numbers[3])
        end
      end
    end
  end

  {samples: samples, instructions: instructions}
end

def get_all_operators
  ['addr', 'addi', 'mulr', 'muli', 'banr', 'bani', 'borr', 'bori', 'setr', 'seti', 'gtir', 'gtri', 'gtrr', 'eqir', 'eqri', 'eqrr']
end

def run_instruction_with_operator(instruction, operator, registers)
  case operator
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

# Fill in operator candidates for each sample and return the answer to part A
def populate_operator_candidates(samples)
  total = 0

  samples.each do |sample|
    get_all_operators().each do |operator|
      test_registers = sample.registers_before.clone
      run_instruction_with_operator(sample.instruction, operator, test_registers)

      sample.operator_candidates << operator if test_registers.join(',') == sample.registers_after.join(',')
    end

    total += 1 if sample.operator_candidates.length >= 3
  end

  total
end

def execute_program(instructions, samples)
  populate_operator_candidates(samples)

  operator_map = {}

  while operator_map.keys.length < get_all_operators().length
    samples.each do |sample|
      next if !operator_map[sample.instruction.opcode].nil?

      sample.operator_candidates -= operator_map.values

      operator_map[sample.instruction.opcode] = sample.operator_candidates[0] if sample.operator_candidates.length == 1
    end
  end

  puts "operators determined:"
  operator_map.each do |key, val|
    puts "#{key} = #{val}"
  end

  registers = [0, 0, 0, 0]

  instructions.each do |instruction|
    # puts "instruction"
    registers = run_instruction_with_operator(instruction, operator_map[instruction.opcode], registers)
  end

  puts instructions.length
  puts registers.join(',')
  registers[0]
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = [Sample.new(Instruction.new(9, 2, 1, 2), [3, 2, 1, 1], [3, 2, 2, 1])]
  puts(populate_operator_candidates(example_input))

  puts("INPUT SOLUTION:")
  file_input = get_program_and_samples_from_file("day16_input.txt")
  puts(populate_operator_candidates(file_input[:samples]))
end

def part_2
  puts("INPUT SOLUTION:")
  file_input = get_program_and_samples_from_file("day16_input.txt")
  puts(execute_program(file_input[:instructions], file_input[:samples]))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
