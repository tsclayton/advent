#!/usr/bin/env ruby

module DanceMove
  Spin = 's'
  Exchange = 'x'
  Partner = 'p'
end

class Instruction
  attr_accessor :dance_move
  attr_accessor :value_1
  attr_accessor :value_2

  def initialize(dance_move, value_1, value_2 = nil)
    @dance_move = dance_move
    @value_1 = value_1
    @value_2 = value_2
  end
end

def parse_file(filename)
  instructions = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      parsed_line = line.gsub(/\s+/, '').split(',')
      parsed_line.each do |instruction|
        dance_move = instruction[0]
        instruction = instruction[1...instruction.length]

        case dance_move
        when DanceMove::Spin
          instructions << Instruction.new(DanceMove::Spin, instruction.to_i)
        when DanceMove::Exchange
          indeces = instruction.split('/').map(&:to_i)
          instructions << Instruction.new(DanceMove::Exchange, indeces[0], indeces[1])
        when DanceMove::Partner
          programs = instruction.split('/')
          instructions << Instruction.new(DanceMove::Partner, programs[0], programs[1])
        end
      end

      return instructions
    end

  end

  instructions
end

def run_instructions(programs, instructions)
  instructions.each do |instruction|
    case instruction.dance_move
    when DanceMove::Spin
      start_index = programs.length - instruction.value_1
      programs = programs[start_index...programs.length] + programs[0...start_index]
    when DanceMove::Exchange, DanceMove::Partner
      index_1 = instruction.dance_move == DanceMove::Exchange ? instruction.value_1 : programs.index(instruction.value_1)
      index_2 = instruction.dance_move == DanceMove::Exchange ? instruction.value_2 : programs.index(instruction.value_2)

      temp = programs[index_1]
      programs[index_1] = programs[index_2]
      programs[index_2] = temp
    end
  end

  programs
end

def gen_program_list(char_1, char_2)
  (char_1.ord..char_2.ord).map(&:chr).join('')
end

def get_min_cycle_length(programs, instructions)
  min_cycle_length = 0
  starting_order = programs.clone
  curr_order = programs.clone

  while true
    min_cycle_length += 1

    curr_order = run_instructions(curr_order, instructions)
    break if starting_order.eql?(curr_order)
  end

  min_cycle_length
end

# Billions and billions of dances
def sagan_dance(programs, instructions)
  min_cycle_length = get_min_cycle_length(programs, instructions)

  for i in 0...(1_000_000_000 % min_cycle_length)
    programs = run_instructions(programs, instructions)
  end

  programs
end

def part_1
  puts("EXAMPLE SOLUTION:")
  instructions = [
    Instruction.new(DanceMove::Spin, 1),
    Instruction.new(DanceMove::Exchange, 3, 4),
    Instruction.new(DanceMove::Partner, 'e', 'b'),
  ]
  puts(run_instructions(gen_program_list('a', 'e'), instructions))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day16_input.txt")
  puts(run_instructions(gen_program_list('a', 'p'), file_input))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  instructions = [
    Instruction.new(DanceMove::Spin, 1),
    Instruction.new(DanceMove::Exchange, 3, 4),
    Instruction.new(DanceMove::Partner, 'e', 'b'),
  ]
  puts(sagan_dance(gen_program_list('a', 'e'), instructions))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day16_input.txt")
  puts(sagan_dance(gen_program_list('a', 'p'), file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
