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

  def add_ascii_input(ascii_input)
    inputs = ascii_input.split('').map(&:ord)
    inputs.each do |input|
      add_input(input)
    end
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

class Bot
  attr_accessor :executor
  attr_accessor :grid

  def initialize(executor)
    @executor = executor
    @grid = []
  end

  def draw_screen()
    output = ""

    while !executor.is_finished
      char = executor.run_program()
      output << char.chr if !char.nil?
    end

    @grid = output.split("\n")
    output
  end

  def get_tile(x, y)
    return '.' if @grid[y].nil? || @grid[y][x].nil?
    return @grid[y][x]
  end

  def get_alignment_parameter_sum()
    alignment_parameter_sum = 0

    for y in 0...@grid.length
      for x in 0...@grid[y].length
        if @grid[y][x] == '#' && get_tile(x + 1, y) == '#' && get_tile(x - 1, y) == '#' && get_tile(x, y + 1) == '#' && get_tile(x, y - 1) == '#'
          alignment_parameter_sum += (x * y)
        end
      end
    end

    alignment_parameter_sum
  end

  def run_course()
    @executor.program[0] = 2

    # Did this manually out of laziness, but could determine the course programatically and then determine the methods by checking if course can be split into 3 repeating segments up until 20 character limit
    #R,12,L,8,R,12,R,8,R,6,R,6,R,8,R,12,L,8,R,12,R,8,R,6,R,6,R,8,R,8,L,8,R,8,R,4,R,4,R,8,L,8,R,8,R,4,R,4,R,8,R,6,R,6,R,8,R,8,L,8,R,8,R,4,R,4,R,8,R,6,R,6,R,8,R,12,L,8,R,12
    @executor.add_ascii_input("A,B,A,B,C,C,B,C,B,A\n")
    @executor.add_ascii_input("R,12,L,8,R,12\n")
    @executor.add_ascii_input("R,8,R,6,R,6,R,8\n")
    @executor.add_ascii_input("R,8,L,8,R,8,R,4,R,4\n")
    @executor.add_ascii_input("n\n")

    result = nil
    while !executor.is_finished
      output = executor.run_program()
      result = output if !output.nil?
    end

    result
  end
end

def alignment_parameter_sum(program)
  executor = Executor.new(program, [])
  bot = Bot.new(executor)
  puts(bot.draw_screen())
  bot.get_alignment_parameter_sum()
end

def run_course(program)
  executor = Executor.new(program, [])
  bot = Bot.new(executor)
  bot.run_course()
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  file_input = get_program_from_file("day17_input.txt")
  puts(alignment_parameter_sum(file_input))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  file_input = get_program_from_file("day17_input.txt")
  puts(run_course(file_input))
end

part_1_final()
part_2_final()