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

class Droid
  attr_accessor :executor
  attr_accessor :map
  attr_accessor :position

  attr_accessor :command_stack
  attr_accessor :oxygen_system_location
  attr_accessor :area_mapped

  def initialize(executor)
    @executor = executor
    @map = {}
    @position = [0, 0]
    @command_stack = []

    @oxygen_system_location = nil
    @area_mapped = false
  end

  def position_for_command(command)
    case command
    when 1
      return [@position[0], @position[1] - 1]
    when 2
      return [@position[0], @position[1] + 1]
    when 3
      return [@position[0] - 1, @position[1]]
    when 4
      return [@position[0] + 1, @position[1]]
    end

    @position
  end

  def get_reverse_command(command)
    [2, 1, 4, 3][command - 1]
  end

  def get_movement_command()
    for dir in 1..4
      next_position = position_for_command(dir)
      if @map[next_position].nil?
        @command_stack.push(dir)
        return dir
      end
    end

    if @command_stack.length > 0
      # Dead-end reached, reverse course
      last_command = @command_stack.pop
      return get_reverse_command(last_command)
    else
      # Allowing the robot to pop off the rest of its command stack while mapping undiscovered tiles after discovering the oxygen system allows it to finish mapping the area
      @area_mapped = true
      return -1
    end
  end

  def droid_step()
    @current_direction = get_movement_command()
    executor.add_input(@current_direction)
    status = executor.run_program()

    case status
    when 0
      # hit wall, position unchanged
      @command_stack.pop()
      wall_position = position_for_command(@current_direction)
      @map[wall_position] = '#'
    when 1
      # moved one step
      @position = position_for_command(@current_direction)
      @map[@position] = '.'
    when 2
      # moved one step and in position of oxygen
      @position = position_for_command(@current_direction)
      @map[@position] = '$'
      @oxygen_system_location = @position
    end
  end

  def locate_oxygen_system()
    while !@executor.is_finished && @oxygen_system_location.nil?
      droid_step()
      # print_map()
    end
  end

  def map_area()
    while !@executor.is_finished && !@area_mapped
      droid_step()
      # print_map()
    end
  end

  def total_steps()
    @command_stack.length
  end

  def minutes_to_oxygenate(position, previous_tiles)
    # There are no paths that loop in on themselves, so we don't need to clone to prevent unwanted mutation
    previous_tiles[position] = true
    directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]

    max_time_to_oxygenate = 0

    directions.each do |direction|
      next_position = [position[0] + direction[0], position[1] + direction[1]]
      if @map[next_position] == '.' && previous_tiles[next_position].nil?
        max_time_to_oxygenate = [max_time_to_oxygenate, 1 + minutes_to_oxygenate(next_position, previous_tiles)].max
      end
    end

    max_time_to_oxygenate
  end

  def print_map
    system "clear"

    min_x = min_y = max_x = max_y = 0

    @map.each do |coords, tile|
      min_x = coords[0] if coords[0] < min_x
      min_y = coords[1] if coords[1] < min_y
      max_x = coords[0] if coords[0] > max_x
      max_y = coords[1] if coords[1] > max_y
    end

    # pattern is flipped in both directions for whatever reason
    for y in min_y..max_y
      line = ''
      for x in min_x..max_x
        if [x, y] == @position
          line << 'D'
        else
          char = @map[[x,y]] || '.'
          line << char
        end
      end
      puts line
    end
  end
end

def quickest_path_to_oxygen_system(program)
  executor = Executor.new(program, [])
  droid = Droid.new(executor)
  droid.locate_oxygen_system()
  droid.total_steps()
end

def minutes_to_oxygenate(program)
  executor = Executor.new(program, [])
  droid = Droid.new(executor)
  droid.map_area()
  droid.minutes_to_oxygenate(droid.oxygen_system_location, {})
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  program = get_program_from_file("day15_input.txt")
  puts(quickest_path_to_oxygen_system(program))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  program = get_program_from_file("day15_input.txt")
  puts(minutes_to_oxygenate(program))
end

part_1_final()
part_2_final()