#!/usr/bin/env ruby

def get_program_from_file(filename)
  File.open(filename, "r") do |file|
    file.each_line do |line|
      return line.gsub(/[\s+]+/, '').split(',').map(&:to_i)
    end
  end

  []
end

class Executor
  attr_accessor :program
  attr_accessor :ip
  attr_accessor :pending_inputs
  attr_accessor :output
  attr_accessor :relative_base

  def initialize(program, inputs)
    @program = program.clone
    @ip = 0
    @relative_base = 0
    @pending_inputs = inputs
  end

  def is_finished()
    @ip >= @program.length
  end

  def add_input(value)
    @pending_inputs << value
  end

  def get_value(value, mode)
    if mode == 0
      return read(value)
    elsif mode == 2
      return read(@relative_base + value)
    end
      
    return value
  end

  def get_address(address, mode)
    if mode == 2
      return @relative_base + address
    elsif mode == 1
      puts "invalid use of immediate mode"
    end
       
     address
  end

  def read(address)
    if address >= @program.length
      for i in @program.length...(address + 1)
        @program[i] = 0
      end
    end

    return @program[address]
  end

  def write(address, value)
    if address >= @program.length
      for i in @program.length...address
        @program[i] = 0
      end
    end

    @program[address] = value
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
        address = get_address(@program[@ip + 3], param_modes[2])
        write(address, param1 + param2)
        @ip = @ip + 4
      when 2
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])
        address = get_address(@program[@ip + 3], param_modes[2])
        write(address, param1 * param2)
        @ip = @ip + 4
      when 3
        if @pending_inputs.length == 0
          # Wait for input
          return nil
        else
          address = get_address(@program[@ip + 1], param_modes[0])
          write(address, @pending_inputs.shift)
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
        address = get_address(@program[@ip + 3], param_modes[2])
        write(address, param1 < param2 ? 1 : 0)
        @ip = @ip + 4
      when 8
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])
        address = get_address(@program[@ip + 3], param_modes[2])
        write(address, param1 == param2 ? 1 : 0)
        @ip = @ip + 4
      when 9
        @relative_base += get_value(@program[@ip + 1], param_modes[0])
        @ip = @ip + 2
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

def run_program(program, inputs)
  executor = Executor.new(program, inputs)
  outputs = []

  while !executor.is_finished
    outputs << executor.run_program()
  end

  outputs.compact.join(",")
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  puts(run_program([109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99], []))
  puts(run_program([1102,34915192,34915192,7,4,7,99,0], []))
  puts(run_program([104,1125899906842624,99], []))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  file_input = get_program_from_file("day9_input.txt")
  puts(run_program(file_input, [1]))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  puts(largest_amplifier_output([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5], (5...10), true))
  puts(largest_amplifier_output([3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10], (5...10), true))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  file_input = get_program_from_file("day9_input.txt")
  puts(run_program(file_input, [2]))
end

part_1_examples()
part_1_final()
part_2_final()