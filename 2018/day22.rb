#!/usr/bin/env ruby

def parse_file(filename)
  grid = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      grid << line.gsub(/\s+/, '').split('').map {|char| char == '#'}
    end
  end

  grid
end

module States
  Cleaned = 'C'
  Weakened = 'W'
  Infected = 'I'
  Flagged = 'F'
end

def make_infinite_hash_grid(grid)
  hash_grid = {}

  centre_row = (grid.length / 2)
  centre_col = (grid[0].length / 2)

  for row in 0...grid.length
    for col in 0...grid[row].length
      # Set centre of grid to 0,0
      # Also swap it so that coords are represented as x,y with positive y being up (for convenience)
      state = grid[row][col] ? States::Infected : States::Cleaned
      hash_grid[[col - centre_col, (grid.length - 1 - row) - centre_row]] = state
    end
  end

  hash_grid
end

class Carrier
  attr_accessor :direction
  attr_accessor :curr_position
  attr_accessor :infecting_bursts
  attr_accessor :is_v2

  def initialize(is_v2 = false)
    @is_v2 = is_v2
    @direction = [0,1]
    @curr_position = [0,0]
    @infecting_bursts = 0
  end

  def move_forward()
    @curr_position = [@curr_position[0] + @direction[0], @curr_position[1] + @direction[1]]
  end

  def turn_right()
    @direction = [@direction[1], -@direction[0]]
  end

  def turn_left
    @direction = [-@direction[1], @direction[0]]
  end

  def burst(hash_grid)
    if @is_v2
      hash_grid[@curr_position] ||= States::Cleaned

      case hash_grid[@curr_position]
      when States::Infected
        turn_right()
        hash_grid[@curr_position] = States::Flagged
      when States::Weakened
        hash_grid[@curr_position] = States::Infected
        @infecting_bursts += 1
      when States::Flagged
        turn_left()
        turn_left()
        hash_grid[@curr_position] = States::Cleaned
      else
        turn_left()
        hash_grid[@curr_position] = States::Weakened
      end

      move_forward()
    else
      hash_grid[@curr_position] ||= States::Cleaned

      if hash_grid[@curr_position] == States::Infected
        turn_right()
        hash_grid[@curr_position] = States::Cleaned
      else
        turn_left()
        hash_grid[@curr_position] = States::Infected
        @infecting_bursts += 1
      end

      move_forward()
    end
  end
end

def num_infecting_bursts(grid, num_bursts, is_v2 = false)
  hash_grid = make_infinite_hash_grid(grid)

  carrier = Carrier.new(is_v2)

  for i in 0...num_bursts
    carrier.burst(hash_grid)
  end

  carrier.infecting_bursts
end

def part_1
  puts("EXAMPLE SOLUTIONS:")
  grid = [
    [false, false, true],
    [true, false, false],
    [false, false, false]
  ]
  puts(num_infecting_bursts(grid, 7))
  puts(num_infecting_bursts(grid, 70))
  puts(num_infecting_bursts(grid, 10_000))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day22_input.txt")
  puts(num_infecting_bursts(file_input, 10_000))
end

def part_2
  puts("EXAMPLE SOLUTIONS:")
  grid = [
    [false, false, true],
    [true, false, false],
    [false, false, false]
  ]
  puts(num_infecting_bursts(grid, 100, true))
  puts(num_infecting_bursts(grid, 10_000_000, true))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day22_input.txt")
  puts(num_infecting_bursts(file_input, 10_000_000, true))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
