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
  attr_accessor :program_copy
  attr_accessor :ip
  attr_accessor :pending_inputs
  attr_accessor :output
  attr_accessor :relative_base

  def initialize(program, inputs)
    @program = program.clone
    @program_copy = program.clone
    @ip = 0
    @relative_base = 0
    @pending_inputs = inputs
  end

  def restart()
    @ip = 0
    @program = @program_copy.clone
    @pending_inputs = []
    @output = 0
    @relative_base = 0
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

class Drone
  attr_accessor :executor
  attr_accessor :grid

  def initialize(executor)
    @executor = executor
    @grid = []
  end

  def get_point(x, y)
    return 0 if (x < 0 || y < 0)
    return 0 if @grid[y].nil? || @grid[y][x].nil?
    return @grid[y][x] || 0
  end

  def set_point(x, y, value)
    @grid[y] ||= []
    @grid[y][x] = value
  end

  def scan_area(max_x, max_y)
    total_sum = 0

    for x in 0...max_x
      for y in 0...max_y
        @executor.add_input(x)
        @executor.add_input(y)
        output = @executor.run_program()
        @executor.restart()
        set_point(x, y, output)
        total_sum += output
      end
    end

    total_sum
  end

  def first_coord_fitting_square(square_size)
    total_sum = 0
    bounds = square_size - 1

    for y in 3...100000
      beam_width = 0
      for x in (y - 3)...100000
        @executor.add_input(x)
        @executor.add_input(y)
        output = @executor.run_program()
        @executor.restart()

        beam_width += output
        set_point(x, y, output)

        break if output == 0 && beam_width > 0

        if get_point(x, y) == 1 && get_point(x - bounds, y) == 1 && get_point(x, y - bounds) == 1 && get_point(x - bounds, y - bounds) == 1
          return [x - bounds, y - bounds]
        end
      end

      total_sum += beam_width
    end

    total_sum
  end

  def print_grid()
    @grid.each do |row|
      if row.nil?
        puts ""
      else
        puts row.map{ |point| point.nil? ? 0 : point }.join('')
      end
    end
  end
end

def points_affected_in_area(program, max_x, max_y)
  executor = Executor.new(program, [])
  drone = Drone.new(executor)
  result = drone.scan_area(max_x, max_y)
  drone.print_grid()
  result
end

def closest_square_coord(program, square_size)
  executor = Executor.new(program, [])
  drone = Drone.new(executor)
  coord = drone.first_coord_fitting_square(square_size)
  coord[0] * 10000 + coord[1]
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  program = get_program_from_file("day19_input.txt")
  puts(points_affected_in_area(program, 50, 50))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  program = get_program_from_file("day19_input.txt")
  puts(closest_square_coord(program, 100))
end

part_1_final()
part_2_final()