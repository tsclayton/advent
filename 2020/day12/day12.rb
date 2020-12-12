#!/usr/bin/env ruby

def get_instructions_from_file(filename)
  File.read(filename).split("\n")
end

class Ship
  attr_accessor :facing_direction
  attr_accessor :current_position
  attr_accessor :instructions
  attr_accessor :waypoint

  def initialize(instructions)
    @instructions = instructions
    @facing_direction = [1, 0]
    @current_position = [0, 0]
    @waypoint = [10, 1]
  end

  def process_instructions(using_waypoint)
    @instructions.each do |instruction|
      direction = instruction[0]
      value = instruction.match(/[0-9]+/).to_s.to_i
      if using_waypoint
        move_waypoint(direction, value)
      else
        move(direction, value)
      end
    end
  end

  def move(direction, value)
    case direction
    when 'N'
      @current_position[1] += value
    when 'S'
      @current_position[1] -= value
    when 'E'
      @current_position[0] += value
    when 'W'
      @current_position[0] -= value
    when 'F'
      @current_position[0] += @facing_direction[0] * value
      @current_position[1] += @facing_direction[1] * value
    else
      turns = value / 90
      for i in 0...turns
        if direction == 'L'
          @facing_direction = [-@facing_direction[1], @facing_direction[0]] 
        elsif direction == 'R'
          @facing_direction = [@facing_direction[1], -@facing_direction[0]]
        end
      end
    end
  end

  def move_waypoint(direction, value)
    case direction
    when 'N'
      @waypoint[1] += value
    when 'S'
      @waypoint[1] -= value
    when 'E'
      @waypoint[0] += value
    when 'W'
      @waypoint[0] -= value
    when 'F'
      @current_position[0] += @waypoint[0] * value
      @current_position[1] += @waypoint[1] * value
    else
      turns = value / 90
      for i in 0...turns
        if direction == 'L'
          @waypoint = [-@waypoint[1], @waypoint[0]] 
        elsif direction == 'R'
          @waypoint = [@waypoint[1], -@waypoint[0]]
        end
      end
    end
  end

  def distance_from_start()
    current_position[0].abs + current_position[1].abs
  end
end

def distance_after_instructions(instructions, using_waypoint)
  ship = Ship.new(instructions)
  ship.process_instructions(using_waypoint)
  ship.distance_from_start()
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  instructions = ['F10','N3','F7','R90','F11']
  puts(distance_after_instructions(instructions, false))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  instructions = get_instructions_from_file('day12_input.txt')
  puts(distance_after_instructions(instructions, false))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  instructions = ['F10','N3','F7','R90','F11']
  puts(distance_after_instructions(instructions, true))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  instructions = get_instructions_from_file('day12_input.txt')
  puts(distance_after_instructions(instructions, true))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()