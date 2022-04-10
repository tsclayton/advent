#!/usr/bin/env ruby

def get_instruction_from_strings(strs)
  instructions = []

  strs.each do |str|
    split_str = str.split(' ')
    instructions << {opcode: split_str[0], x: split_str[1], y: split_str[2]}
  end

  instructions
end

class Computer
  attr_accessor :registers
  attr_accessor :instructions
  attr_accessor :ip

  def initialize(instructions)
    @registers = {'a' => 0, 'b' => 0, 'c' => 0, 'd' => 0}
    @instructions = instructions
    @ip = 0
  end

  def run_program()
    while @ip < @instructions.length
      instruction = @instructions[@ip]

      case instruction[:opcode]
        when 'cpy'
          @registers[instruction[:y]] = get_value(instruction[:x])
        when 'inc'
          @registers[instruction[:x]] += 1
        when 'dec'
          @registers[instruction[:x]] -= 1
        when 'jnz'
          @ip += (get_value(instruction[:y]) - 1) if get_value(instruction[:x]) != 0
      end

      @ip += 1
    end
  end

  def get_value(v)
    if !@registers[v].nil?
      return @registers[v]
    end

    v.to_i
  end
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  instructions = get_instruction_from_strings([
    'cpy 41 a',
    'inc a',
    'inc a',
    'dec a',
    'jnz a 2',
    'dec a'
  ])

  c = Computer.new(instructions)
  c.run_program()
  puts(c.registers['a'])
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  instructions = get_instruction_from_strings([
    'cpy 1 a',
    'cpy 1 b',
    'cpy 26 d',
    'jnz c 2',
    'jnz 1 5',
    'cpy 7 c',
    'inc d',
    'dec c',
    'jnz c -2',
    'cpy a c',
    'inc a',
    'dec b',
    'jnz b -2',
    'cpy c b',
    'dec d',
    'jnz d -6',
    'cpy 16 c',
    'cpy 17 d',
    'inc a',
    'dec d',
    'jnz d -2',
    'dec c',
    'jnz c -5'
  ])

  c = Computer.new(instructions)
  c.run_program()
  puts(c.registers['a'])
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  instructions = get_instruction_from_strings([
    'cpy 1 a',
    'cpy 1 b',
    'cpy 26 d',
    'jnz c 2',
    'jnz 1 5',
    'cpy 7 c',
    'inc d',
    'dec c',
    'jnz c -2',
    'cpy a c',
    'inc a',
    'dec b',
    'jnz b -2',
    'cpy c b',
    'dec d',
    'jnz d -6',
    'cpy 16 c',
    'cpy 17 d',
    'inc a',
    'dec d',
    'jnz d -2',
    'dec c',
    'jnz c -5'
  ])

  c = Computer.new(instructions)
  c.registers['c'] = 1
  c.run_program()
  puts(c.registers['a'])
end

part_1_example()
part_1_final()
part_2_final()