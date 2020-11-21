#!/usr/bin/env ruby

def get_program_from_file(filename)
  File.open(filename, "r") do |file|
    file.each_line do |line|
      return line.gsub(/[\s+]+/, '').split(',').map(&:to_i)
    end
  end

  []
end

class Amplifier
  attr_accessor :program
  attr_accessor :phase
  attr_accessor :ip
  attr_accessor :pending_inputs
  attr_accessor :output

  def initialize(program, phase)
    @program = program.clone
    @phase = phase
    @ip = 0
    @pending_inputs = [@phase]
  end

  def is_finished()
    @ip >= @program.length
  end

  def add_input(value)
    @pending_inputs << value
  end

  def get_value(value, mode)
    if mode == 0
      return @program[value]
    end

    return value
  end

  def run_program()
    while @ip < @program.length
      instruction = @program[@ip]
      opcode = instruction % 100
      param_modes = [(instruction / 100) % 10, (instruction / 1000) % 10, (instruction / 10000) % 10]

      case opcode
      when 1
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])
        @program[@program[@ip + 3]] = param1 + param2
        @ip = @ip + 4
      when 2
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])
        @program[@program[@ip + 3]] = param1 * param2
        @ip = @ip + 4
      when 3
        if @pending_inputs.length == 0
          # Wait for input
          return nil
        else
          @program[@program[@ip + 1]] = @pending_inputs.shift
          @ip = @ip + 2
        end
      when 4
        @output = get_value(@program[@ip + 1], param_modes[0])
        @ip = @ip + 2
        return @output
      when 5
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])

        if param1 != 0
          @ip = param2
        else
          @ip = @ip + 3
        end
      when 6
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])

        if param1 == 0
          @ip = param2
        else
          @ip = @ip + 3
        end
      when 7
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])
        @program[@program[@ip + 3]] = (param1 < param2 ? 1 : 0)
        @ip = @ip + 4
      when 8
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])
        @program[@program[@ip + 3]] = (param1 == param2 ? 1 : 0)
        @ip = @ip + 4
      when 99
        # Halt by advancing @IP past @program length
        @ip = @program.length
      else
        puts("SOMETHING WENT WRONG! instruction = #{instruction}, @ip = #{@ip}")
        @ip = @program.length
      end
    end

    nil
  end
end

def run_sequence_with_phases(program, phases, feedback)
  amplifiers = []

  phases.each do |phase|
    amplifiers << Amplifier.new(program, phase)
  end

  prev_output = 0

  while true
    for i in 0...amplifiers.length
      amplifier = amplifiers[i]

      if !prev_output.nil?
        amplifier.add_input(prev_output)
      end

      if !amplifier.is_finished
        prev_output = amplifier.run_program()
      end
    end
      
    terminate = true

    if feedback
      for j in 0...amplifiers.length
        if !amplifiers[j].is_finished
          terminate = false
          break
        end
      end
    end

    break if terminate
  end

  amplifiers[amplifiers.length - 1].output
end

def largest_amplifier_output(program, phase_range, feedback)
  largest_output = 0
  phase_combinations = phase_range.to_a.permutation.to_a

  phase_combinations.each do |phases|
    thruster_output = run_sequence_with_phases(program, phases, feedback)

    if thruster_output > largest_output
      largest_output = thruster_output
    end
  end

  largest_output
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  puts(largest_amplifier_output([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0], (0...5), false))
  puts(largest_amplifier_output([3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0], (0...5), false))
  puts(largest_amplifier_output([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0], (0...5), false))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  file_input = get_program_from_file("day7_input.txt")
  puts(largest_amplifier_output(file_input, (0...5), false))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  puts(largest_amplifier_output([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5], (5...10), true))
  puts(largest_amplifier_output([3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10], (5...10), true))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  file_input = get_program_from_file("day7_input.txt")
  puts(largest_amplifier_output(file_input, (5...10), true))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()