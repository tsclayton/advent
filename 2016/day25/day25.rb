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
  attr_accessor :output
  attr_accessor :is_clock_signal

  attr_accessor :CHECK_CYCLE_LENGTH

  def initialize(instructions)
    @registers = {'a' => 0, 'b' => 0, 'c' => 0, 'd' => 0}
    @instructions = instructions
    @ip = 0
    @output = []
    @is_clock_signal = false

    @CHECK_CYCLE_LENGTH = 10
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
        when 'out'
          @output << get_value(instruction[:x])
          if @output.length > @CHECK_CYCLE_LENGTH && @output[0...@CHECK_CYCLE_LENGTH].join == ("01" * (@CHECK_CYCLE_LENGTH / 2))
            @is_clock_signal = true
            @ip = @instructions.length
          elsif @output.length > @CHECK_CYCLE_LENGTH
            @ip = @instructions.length
          end
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

    if instruction[:y].nil?
      instruction[:opcode] = (instruction[:opcode] == 'inc' ? 'dec' : 'inc')
    else
      instruction[:opcode] = (instruction[:opcode] == 'jnz' ? 'cpy' : 'jnz')
    end
  end
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  instructions = get_instruction_from_strings([
    'cpy a d',
    'cpy 15 c',
    'cpy 170 b',
    'inc d',
    'dec b',
    'jnz b -2',
    'dec c',
    'jnz c -5',
    'cpy d a',
    'jnz 0 0',
    'cpy a b',
    'cpy 0 a',
    'cpy 2 c',
    'jnz b 2',
    'jnz 1 6',
    'dec b',
    'dec c',
    'jnz c -4',
    'inc a',
    'jnz 1 -7',
    'cpy 2 b',
    'jnz c 2',
    'jnz 1 4',
    'dec b',
    'dec c',
    'jnz 1 -4',
    'jnz 0 0',
    'out b',
    'jnz a -19',
    'jnz 1 -21'
  ])

  lowest_a = 0

  while lowest_a < 1_000_000
    c = Computer.new(instructions)
    c.registers['a'] = lowest_a
    c.run_program()

    break if c.is_clock_signal

    lowest_a += 1
  end

  puts(lowest_a)
end

part_1_final()