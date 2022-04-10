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

      # TODO: Skip invalid instructions?

      case instruction[:opcode]
        when 'cpy'
          @registers[instruction[:y]] = get_value(instruction[:x])
        when 'inc'
          @registers[instruction[:x]] += 1
        when 'dec'
          @registers[instruction[:x]] -= 1
        when 'jnz'
          @ip += (get_value(instruction[:y]) - 1) if get_value(instruction[:x]) != 0
        when 'tgl'
          toggle(@ip + get_value(instruction[:x]))
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

  def toggle(ip)
    return if ip >= @instructions.length

    instruction = @instructions[ip]
    # puts "toggling at ip = #{ip}"
    # puts "before:"
    # puts @instructions

    if instruction[:y].nil?
      instruction[:opcode] = (instruction[:opcode] == 'inc' ? 'dec' : 'inc')
    else
      instruction[:opcode] = (instruction[:opcode] == 'jnz' ? 'cpy' : 'jnz')
    end


    # puts "after:"
    # puts @instructions
  end
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  instructions = get_instruction_from_strings([
    'cpy 2 a',
    'tgl a',
    'tgl a',
    'tgl a',
    'cpy 1 a',
    'dec a',
    'dec a'
  ])

  c = Computer.new(instructions)
  c.run_program()
  puts(c.registers['a'])
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  instructions = get_instruction_from_strings([
    'cpy a b',
    'dec b',
    'cpy a d',
    'cpy 0 a',
    'cpy b c',
    'inc a',
    'dec c',
    'jnz c -2',
    'dec d',
    'jnz d -5',
    'dec b',
    'cpy b c',
    'cpy c d',
    'dec d',
    'inc c',
    'jnz d -2',
    'tgl c',
    'cpy -16 c',
    'jnz 1 c',
    'cpy 89 c',
    'jnz 84 d',
    'inc a',
    'inc d',
    'jnz d -2',
    'inc c',
    'jnz c -5'
  ])

  c = Computer.new(instructions)
  c.registers['a'] = 7
  c.run_program()
  puts(c.registers['a'])
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  instructions = get_instruction_from_strings([
    'cpy a b',
    'dec b',
    'cpy a d',
    'cpy 0 a',
    'cpy b c',
    'inc a',
    'dec c',
    'jnz c -2',
    'dec d',
    'jnz d -5',
    'dec b',
    'cpy b c',
    'cpy c d',
    'dec d',
    'inc c',
    'jnz d -2',
    'tgl c',
    'cpy -16 c',
    'jnz 1 c',
    'cpy 89 c',
    'jnz 84 d',
    'inc a',
    'inc d',
    'jnz d -2',
    'inc c',
    'jnz c -5'
  ])

  c = Computer.new(instructions)
  c.registers['a'] = 12
  c.run_program()
  puts(c.registers['a'])
end

part_1_example()
part_1_final()
part_2_final()