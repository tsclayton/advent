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

class Painter
  attr_accessor :direction
  attr_accessor :current_position
  attr_accessor :map
  attr_accessor :executor

  def initialize(executor)
    @direction = [0,1]
    @current_position = [0,0]
    @map = {}
    @executor = executor
  end

  def turn_left()
    @direction = [@direction[1], -@direction[0]]
  end

  def turn_right()
    @direction = [-@direction[1], @direction[0]]
  end

  def advance()
    @current_position[0] += @direction[0]
    @current_position[1] += @direction[1]
  end

  def paint(x, y, colour)
    @map[[x,y]] = colour
  end

  def current_colour()
    if @map[@current_position].nil?
      return "."
    end

    @map[@current_position]
  end

  def panels_painted()
    num_painted = 0

    @map.each do |coords, colour|
      num_painted += 1
    end

    num_painted
  end

  def step()
    input = 0
    curr_colour = current_colour
    if (curr_colour == '#')
      input = 1
    end

    executor.add_input(input)
    colour_output = executor.run_program()

    if !colour_output.nil?
      paint_colour = '.'
      if colour_output == 0
        paint_colour = '.'
      elsif colour_output == 1
        paint_colour = '#'
      end

      @map[[@current_position[0], @current_position[1]]] = paint_colour

      direction_output = executor.run_program()

      if !direction_output.nil?
        if direction_output == 0
          turn_left()
        elsif direction_output == 1
          turn_right()
        end

        advance()
      end
    end
  end

  def run_program()
    while !executor.is_finished
      step()
    end
  end

  def print_map
    min_x = 0
    min_y = 0
    max_x = 0
    max_y = 0

    @map.each do |coords, colour|
      min_x = coords[0] if coords[0] < min_x
      min_y = coords[1] if coords[1] < min_y
      max_x = coords[0] if coords[0] > max_x
      max_y = coords[1] if coords[1] > max_y
    end

    # pattern is flipped in both directions for whatever reason
    for y in (min_y..max_y).to_a.reverse
      line = ''
      for x in (min_x..max_x).to_a.reverse
        char = @map[[x,y]] || '.'
        line << char
      end
      puts line
    end
  end
end

def num_panels_painted(program)
  executor = Executor.new(program, [])
  painter = Painter.new(executor)
  painter.run_program()
  painter.panels_painted()
end

def get_registration(program)
  executor = Executor.new(program, [])
  painter = Painter.new(executor)
  painter.map[[0,0]] = '#'
  painter.run_program()
  painter.print_map()
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  file_input = get_program_from_file("day11_input.txt")
  puts(num_panels_painted(file_input))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  file_input = get_program_from_file("day11_input.txt")
  get_registration(file_input)
end

part_1_final()
part_2_final()