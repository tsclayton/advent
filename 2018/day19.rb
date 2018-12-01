#!/usr/bin/env ruby

def parse_file(filename)
  grid = []
  row = 0

  File.open(filename, "r") do |file|
    file.each_line do |line|
      grid[row] = line.split('')[0...(line.length - 1)]
      row += 1
    end
  end

  grid
end

def get_starting_point(grid)
  [0, grid[0].find_index('|')]
end

def forward(coords, direction)
  [coords[0] + direction[0], coords[1] + direction[1]]
end

def left(direction)
  [direction[1], direction[0]]
end

def right(direction)
  [-direction[1], -direction[0]]
end

def is_letter?(char)
  char.match(/[A-z]/) != nil
end

def char_at(grid, coords)
  if grid[coords[0]] != nil
    return grid[coords[0]][coords[1]] || ' '
  end

  ' '
end

def traverse_grid(grid)
  coords = get_starting_point(grid)
  direction = [1, 0]
  letters = ''
  num_steps = 0

  while true
    coords = forward(coords, direction)
    num_steps += 1
    curr_char = char_at(grid, coords)

    case curr_char
    when ' '
      break
    when '+'
      left_coords = forward(coords, left(direction))
      direction = char_at(grid, left_coords) != ' ' ? left(direction) : right(direction)
    else
      # If - or |, just keep going in the same direction
      letters << curr_char if is_letter?(curr_char)
    end
  end

  {letters: letters, num_steps: num_steps}
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = parse_file("day19_example.txt")
  puts(traverse_grid(example_input)[:letters])
  puts("INPUT SOLUTION:")
  file_input = parse_file("day19_input.txt")
  puts(traverse_grid(file_input)[:letters])
end

def part_2
  puts("EXAMPLE SOLUTION:")
  example_input = parse_file("day19_example.txt")
  puts(traverse_grid(example_input)[:num_steps])
  puts("INPUT SOLUTION:")
  file_input = parse_file("day19_input.txt")
  puts(traverse_grid(file_input)[:num_steps])
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
