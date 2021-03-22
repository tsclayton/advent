#!/usr/bin/env ruby

class Instruction
  attr_accessor :opcode
  attr_accessor :value1
  attr_accessor :value2

  def initialize(opcode, value1, value2 = nil)
    @opcode = opcode
    @value1 = value1
    @value2 = value2
  end
end

def instruction_from_string(str)
  instruction = nil

  if str[0...4] == 'mask'
    instruction = Instruction.new('mask', str.match(/[X01]+/).to_s)
  elsif str[0...3] == 'mem'
    split_instruction = str.split(' = ')
    instruction = Instruction.new('mem', split_instruction[0].match(/[0-9]+/).to_s.to_i, split_instruction[1].match(/[0-9]+/).to_s.to_i)
  else
    puts('Invalid instruction')
  end

  instruction
end

def get_instructions_from_file(filename)
  File.read(filename).split("\n").map {|str| instruction_from_string(str)}
end

def process_instructions(instructions)
  memory = []
  current_mask = ''

  instructions.each do |instruction|
    if instruction.opcode == 'mask'
      current_mask = instruction.value1
    elsif instruction.opcode == 'mem'
      address = instruction.value1
      # lazy way to get the bit strings to match sizes
      value_string = (instruction.value2 | 2.pow(35)).to_s(2)
      value_string[0] = '0'

      for i in 0...current_mask.length
        bit = current_mask[i]
        value_string[i] = current_mask[i] if bit != 'X'
      end

      memory[address] = value_string.to_i(2)
    end
  end

  memory
end

def memory_sum_after_instructions(instructions)
  memory = process_instructions(instructions)
  memory.compact.sum
end

def get_all_addresses(bit_string)
  combos = [bit_string]

  while !combos[0].index('X').nil?
    new_combos = []

    combos.each do |bs|
      new_combos << bs.sub('X', '0')
      new_combos << bs.sub('X', '1')
    end

    combos = new_combos
  end

  combos
end

def process_decoder_instructions(instructions)
  memory = {}
  current_mask = ''

  addresses_to_write = {}

  instructions.each do |instruction|
    if instruction.opcode == 'mask'
      current_mask = instruction.value1
    elsif instruction.opcode == 'mem'
      # lazy way to get the bit strings to match sizes
      address_string = (instruction.value1 | 2.pow(35)).to_s(2)
      address_string[0] = '0'
      value = instruction.value2

      for i in 0...current_mask.length
        bit = current_mask[i]
        address_string[i] = current_mask[i] if bit == 'X' || bit == '1'
      end

      addresses_to_write[address_string] = value
    end
  end

  addresses_to_write.each do |address_string, value|
    addresses = get_all_addresses(address_string)
    addresses.each do |address|
      memory[address] = value
    end
  end

  memory.values
end

def memory_sum_after_decoder_instructions(instructions)
  memory = process_decoder_instructions(instructions)
  memory.compact.sum
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  instructions = [
    'mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X',
    'mem[8] = 11',
    'mem[7] = 101',
    'mem[8] = 0'
  ].map {|str| instruction_from_string(str)}
  puts(memory_sum_after_instructions(instructions))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  instructions = get_instructions_from_file('day14_input.txt')
  puts(memory_sum_after_instructions(instructions))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  instructions = [
    'mask = 000000000000000000000000000000X1001X',
    'mem[42] = 100',
    'mask = 00000000000000000000000000000000X0XX',
    'mem[26] = 1'
  ].map {|str| instruction_from_string(str)}
  puts(memory_sum_after_decoder_instructions(instructions))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  instructions = get_instructions_from_file('day14_input.txt')
  puts(memory_sum_after_decoder_instructions(instructions))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()