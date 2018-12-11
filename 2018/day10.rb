#!/usr/bin/env ruby

class Light
  # I'll just represent these as arrays of 2 ints
  attr_accessor :position
  attr_accessor :velocity

  def initialize(position, velocity)
    @position = position
    @velocity = velocity
  end
end

def get_lights_from_file(filename)
  lights = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      numbers = line.scan(/-*[0-9]+/).map(&:to_i)
      lights << Light.new([numbers[0], numbers[1]], [numbers[2], numbers[3]])
    end
  end

  lights
end

def print_secret_message(lights)
  seconds = 0
  min_distance_sum = nil

  while true
    seconds += 1

    lights.each do |light|
      light.position[0] += light.velocity[0]
      light.position[1] += light.velocity[1]
    end

    distance_sum = 0
    for i in 0...(lights.length - 1)
      distance_sum += (lights[i].position[0] - lights[i + 1].position[0]).abs + (lights[i].position[1] - lights[i + 1].position[1]).abs
    end

    # Keep going until the points are closest together
    break if !min_distance_sum.nil? && distance_sum > min_distance_sum

    min_distance_sum = distance_sum
  end

  min_x = min_y = max_x = max_y = nil

  lights.each do |light|
    light.position[0] -= light.velocity[0]
    light.position[1] -= light.velocity[1]

    min_x = light.position[0] if min_x.nil? || light.position[0] < min_x
    min_y = light.position[1] if min_y.nil? || light.position[1] < min_y
    max_x = light.position[0] if max_x.nil? || light.position[0] > max_x
    max_y = light.position[1] if max_y.nil? || light.position[1] > max_y
  end

  # grid = (y, x) for easier printing
  grid = []

  for i in 0...((max_y - min_y).abs + 1)
    grid[i] = []
  end

  lights.each do |light|
    grid[light.position[1] - min_y][light.position[0] - min_x] = true
  end

  grid.each do |row|
    row_string = row.map { |x| x.nil? ? '.' : '#'}.join('')
    puts row_string
  end

  seconds
end

def parts_1_and_2
  puts("EXAMPLE SOLUTION:")
  example_input = get_lights_from_file("day10_example.txt")
  puts(print_secret_message(example_input))
  puts("INPUT SOLUTION:")
  file_input = get_lights_from_file("day10_input.txt")
  puts(print_secret_message(file_input))
end

puts("SOLUTIONS:")
parts_1_and_2()
