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

def first_frequency_recovery(instructions)
  curr_index = 0
  last_freq = 0
  registers = {}

  while true
    curr_instruction = instructions[curr_index]
    registers[curr_instruction.lhs] ||= 0 if is_register?(curr_instruction.lhs)

    rhs = curr_instruction.get_rhs(registers)

    case curr_instruction.operation
    when 'snd'
      last_freq = curr_instruction.get_lhs(registers)
    when 'set'
      registers[curr_instruction.lhs] = rhs
    when 'add'
      registers[curr_instruction.lhs] += rhs
    when 'mul'
      registers[curr_instruction.lhs] *= rhs
    when 'mod'
      registers[curr_instruction.lhs] %= rhs
    when 'rcv'
      return last_freq if curr_instruction.get_lhs(registers) > 0
    when 'jgz'
      curr_index += rhs - 1 if curr_instruction.get_lhs(registers) > 0
    end

    curr_index += 1
  end

  0
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = parse_file("day18_example.txt")
  puts(first_frequency_recovery(example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day18_input.txt")
  puts(first_frequency_recovery(file_input))
end

class Program
  attr_accessor :registers
  attr_accessor :message_queue
  attr_accessor :curr_index
  attr_accessor :send_count
  attr_accessor :is_waiting
  attr_accessor :proc_pointer

  def initialize(pid)
    @registers = {'p' => pid}
    @message_queue = []
    @curr_index = 0
    @send_count = 0
  end

  def is_running(instructions)
    !@is_waiting && @curr_index < instructions.length
  end

  def process_current_instruction(instructions)
    instruction = instructions[@curr_index]
    @registers[instruction.lhs] ||= 0 if is_register?(instruction.lhs)

    rhs = instruction.get_rhs(@registers)

    case instruction.operation
    when 'snd'
      @send_count += 1
      proc_pointer.message_queue << instruction.get_lhs(@registers)
    when 'set'
      @registers[instruction.lhs] = rhs
    when 'add'
      @registers[instruction.lhs] += rhs
    when 'mul'
      @registers[instruction.lhs] *= rhs
    when 'mod'
      @registers[instruction.lhs] %= rhs
    when 'rcv'
      if message_queue.length == 0
        @is_waiting = true
        return
      end

      @registers[instruction.lhs] = @message_queue.shift
    when 'jgz'
      @curr_index += rhs - 1 if instruction.get_lhs(@registers) > 0
    end

    @curr_index += 1
  end
end

def program_sends_before_termination(instructions)
  proc_0 = Program.new(0)
  proc_1 = Program.new(1)

  proc_0.proc_pointer = proc_1
  proc_1.proc_pointer = proc_0

  while proc_0.is_running(instructions) || proc_1.is_running(instructions)
    proc_0.process_current_instruction(instructions)
    proc_1.process_current_instruction(instructions)
  end

  proc_1.send_count
end

def part_2
  puts("EXAMPLE SOLUTION:")
  example_input = parse_file("day18_example2.txt")
  puts(program_sends_before_termination(example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day18_input.txt")
  puts(program_sends_before_termination(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
