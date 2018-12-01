#!/usr/bin/env ruby

def parse_file(filename)
  rules = {}

  File.open(filename, "r") do |file|
    file.each_line do |line|
      parsed_line = line.gsub(/\s+/,'').split('=>')
      rules[parsed_line[0]] = parsed_line[1]
    end
  end

  rules
end

def string_from_grid(grid)
  grid.map(&:join).join('/')
end

def grid_from_string(string)
  string.split('/').map { |row| row.split('') }
end

def print_grid(grid)
  grid.each do |row|
    puts row.join
  end
end

def add_flipped_rotate_rules(rules)
  new_rules = {}

  rules.each do |input, output|
    new_rules[input] = output

    input_grid = grid_from_string(input)

    rotations = [input_grid]
    curr_grid = input_grid.map(&:clone)
    for i in 0...3
      rotation = []
      for row in 0...curr_grid.length
        rotation[row] = []
        for col in 0...curr_grid[row].length
          rotation[row][col] = curr_grid[curr_grid[row].length - 1 - col][row]
        end
      end

      rotations << rotation
      curr_grid = rotation.map(&:clone)
    end

    rotations.each do |rotation|
      new_rules[string_from_grid(rotation)] = output
      verticle_flip = rotation.reverse
      horizontal_flip = rotation.map(&:reverse)

      new_rules[string_from_grid(verticle_flip)] = output
      new_rules[string_from_grid(horizontal_flip)] = output
    end
  end

  new_rules
end

def split_into_sub_grids(grid)
  sub_grids = []
  sub_grid_size = 0

  if grid.length % 2 == 0
    sub_grid_size = 2
  elsif grid.length % 3 == 0
    sub_grid_size = 3
  else
    puts "ERROR: indivisible grid of size #{grid.length}"
    return [grid]
  end

  sub_grids_length = grid.length / sub_grid_size

  for row in 0...sub_grids_length
    sub_grids[row] = []
    for col in 0...sub_grids_length
      sub_grid = []
      for i in 0...sub_grid_size
        sub_grid[i] = []
        for j in 0...sub_grid_size
          sub_grid[i][j] = grid[row * sub_grid_size + i][col * sub_grid_size + j]
        end
      end

      sub_grids[row][col] = sub_grid
    end
  end

  sub_grids
end

def join_sub_grids(sub_grids)
  grid = []
  for row in 0...sub_grids.length
    for col in 0...sub_grids[row].length
      sub_grid_size = sub_grids[row][col].length
      for i in 0...sub_grid_size
        for j in 0...sub_grid_size
          grid[row * sub_grid_size + i] ||= []
          grid[row * sub_grid_size + i][col * sub_grid_size + j] = sub_grids[row][col][i][j]
        end
      end
    end
  end

  grid
end

def tighten_up_those_graphics(rules, iterations)
  rules = add_flipped_rotate_rules(rules)
  grid = [
    ['.', '#', '.'],
    ['.', '.', '#'],
    ['#', '#', '#']
  ]

  for i in 0...iterations
    sub_grids = split_into_sub_grids(grid)

    sub_grids = sub_grids.map do |sub_grids_row|
      sub_grids_row.map do |sub_grid|
        grid_string = string_from_grid(sub_grid)
        rule_output = rules[grid_string]
        grid_from_string(rule_output)
      end
    end

    grid = join_sub_grids(sub_grids)
  end

  grid
end

def number_of_on_cells(rules, iterations)
  grid = tighten_up_those_graphics(rules, iterations)
  num_on = 0

  for row in 0...grid.length
    for col in 0...grid[row].length
      num_on += 1 if grid[row][col] == '#'
    end
  end

  num_on
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_rules = {
    '../.#' => '##./#../...',
    '.#./..#/###' => '#..#/..../..../#..#'
  }
  puts(number_of_on_cells(example_rules, 2))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day21_input.txt")
  puts(number_of_on_cells(file_input, 5))
end

def part_2
  puts("INPUT SOLUTION:")
  file_input = parse_file("day21_input.txt")
  puts(number_of_on_cells(file_input, 18))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
