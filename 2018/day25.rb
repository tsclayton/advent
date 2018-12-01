#!/usr/bin/env ruby

class BitRule
  attr_accessor :bit_to_write
  attr_accessor :slot_increment
  attr_accessor :next_state

  def initialize(bit_to_write, slot_increment, next_state)
    @slot_increment = slot_increment
    @bit_to_write = bit_to_write
    @next_state = next_state
  end
end

class TuringMachine
  attr_accessor :rules
  attr_accessor :num_steps

  attr_accessor :curr_state
  attr_accessor :curr_index

  attr_accessor :tape

  def initialize(rules, num_steps, starting_state)
    @rules = rules
    @num_steps = num_steps
    @curr_state = starting_state
    @curr_index = 0
    @tape = {}
  end

  def checksum()
    @tape.values.reduce(:+)
  end

  def run()
    for i in 0...@num_steps
      @tape[curr_index] ||= 0
      bit_rule = @rules[@curr_state][@tape[curr_index]]
      @tape[curr_index] = bit_rule.bit_to_write
      @curr_index += bit_rule.slot_increment
      @curr_state = bit_rule.next_state
    end
  end
end

def get_example_machine()
  rules = {
    'A' => [BitRule.new(1, 1, 'B'), BitRule.new(0, -1, 'B')],
    'B' => [BitRule.new(1, -1, 'A'), BitRule.new(1, 1, 'A')]
  }
  TuringMachine.new(rules, 6, 'A')
end

def get_input_machine()
  rules = {
    'A' => [BitRule.new(1, 1, 'B'), BitRule.new(0, 1, 'C')],
    'B' => [BitRule.new(0, -1, 'A'), BitRule.new(0, 1, 'D')],
    'C' => [BitRule.new(1, 1, 'D'), BitRule.new(1, 1, 'A')],
    'D' => [BitRule.new(1, -1, 'E'), BitRule.new(0, -1, 'D')],
    'E' => [BitRule.new(1, 1, 'F'), BitRule.new(1, -1, 'B')],
    'F' => [BitRule.new(1, 1, 'A'), BitRule.new(1, 1, 'E')]
  }
  TuringMachine.new(rules, 12368930, 'A')
end

def run_diagnostic_checksum(machine)
  machine.run()
  machine.checksum()
end

def part_1
  puts("EXAMPLE SOLUTION:")
  puts(run_diagnostic_checksum(get_example_machine()))
  puts("INPUT SOLUTION:")
  puts(run_diagnostic_checksum(get_input_machine()))
end

def part_2
  puts("Nothing, apparently")
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
