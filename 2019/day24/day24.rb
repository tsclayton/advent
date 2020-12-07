#!/usr/bin/env ruby

def bug_at_tile(grid, x, y)
  return false if x < 0 || y < 0 || y >= grid.length || x >= grid[y].length
  return grid[y][x] == '#'
end

def game_of_life_step(grid)
  directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  new_grid = []

  for y in 0...grid.length
    new_grid[y] = ''

    for x in 0...grid[y].length
      adjacent_bugs = 0
      directions.each do |direction|
        adjacent_bugs += 1 if bug_at_tile(grid, x + direction[0], y + direction[1])
      end

      if grid[y][x] == '.'
        new_grid[y] << ((adjacent_bugs == 1 || adjacent_bugs == 2) ? '#' : '.')
      else
        new_grid[y] << ((adjacent_bugs == 1) ? '#' : '.')
      end
    end
  end

  new_grid
end

def first_repeat_grid_state(grid)
  previous_states = {}
  directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  while true
    state_string = grid.join("\n")
    if previous_states[state_string].nil?
      previous_states[state_string] = true
    else
      break
    end

    grid = game_of_life_step(grid)
  end

  grid
end

def biodiversity_rating(grid)
  rating = 0

  for y in 0...grid.length
    for x in 0...grid[y].length
      if grid[y][x] == '#'
        tile_num = (x % grid[y].length) + (y * grid.length)
        rating += 2.pow(tile_num)
      end
    end
  end

  rating
end

def rating_of_first_repeat(grid)
  repeat_state = first_repeat_grid_state(grid)
  puts repeat_state
  biodiversity_rating(repeat_state)
end

class RecursiveGrid
  attr_accessor :depth
  attr_accessor :grid
  attr_accessor :pending_new_grid

  attr_accessor :child
  attr_accessor :parent

  def initialize(depth, grid)
    @depth = depth
    @grid = grid
    @pending_new_grid = []
    @child = nil
    @parent = nil
  end

  def get_top_level()
    return self if @parent.nil?

    @parent.get_top_level()
  end

  def generate_parent
    if @parent.nil?
      # Generate parent only if there's a bug on the edge
      for i in 0...5
        if bug_at_tile(i, 0) || bug_at_tile(i, 4) || bug_at_tile(0, i) || bug_at_tile(4, i)
          @parent = RecursiveGrid.new(depth - 1, [
            '.....',
            '.....',
            '..?..',
            '.....',
            '.....'
          ])
          @parent.child = self
          break
        end
      end
    else
      @parent.generate_parent()
    end
  end

  def generate_child
    # Generate child only if there's a bug on a tile that neighbours the centre
    if @child.nil?
      if bug_at_tile(2, 1) || bug_at_tile(2, 3) || bug_at_tile(1, 2) || bug_at_tile(3, 2)
        @child = RecursiveGrid.new(depth + 1, [
          '.....',
          '.....',
          '..?..',
          '.....',
          '.....'
        ])
        @child.parent = self
      end
    else
      @child.generate_child()
    end
  end

  def bug_at_tile(x, y)
    if x == 2 && y == 2
      # Should go through child instead
      return false
    end

    return @grid[y][x] == '#'
  end

  def num_adjacent_bugs(x, y)
    adjacent_bugs = 0

    directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    directions.each do |direction|
      tile = [x + direction[0], y + direction[1]]

      if tile[0] == 2 && tile[1] == 2
        next if @child.nil?

        child_neighbours = []
        child_neighbours = [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4]] if x == 1 && y == 2
        child_neighbours = [[4, 0], [4, 1], [4, 2], [4, 3], [4, 4]] if x == 3 && y == 2
        child_neighbours = [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0]] if x == 2 && y == 1
        child_neighbours = [[0, 4], [1, 4], [2, 4], [3, 4], [4, 4]] if x == 2 && y == 3

        child_neighbours.each do |child_neighbour|
          adjacent_bugs += 1 if @child.bug_at_tile(child_neighbour[0], child_neighbour[1])
        end
      elsif tile[0] < 0 || tile[1] < 0 || tile[1] >= grid.length || tile[0] >= grid[tile[1]].length
        next if @parent.nil?

        parent_neighbour = []
        parent_neighbour = [1, 2] if tile[0] < 0
        parent_neighbour = [2, 1] if tile[1] < 0
        parent_neighbour = [3, 2] if tile[0] >= grid.length
        parent_neighbour = [2, 3] if tile[1] >= grid.length

        adjacent_bugs += 1 if @parent.bug_at_tile(parent_neighbour[0], parent_neighbour[1])
      else
        adjacent_bugs += 1 if bug_at_tile(tile[0], tile[1])
      end
    end

    adjacent_bugs
  end

  def game_of_life_step
    @pending_new_grid = []

    for y in 0...@grid.length
      @pending_new_grid[y] = ''

      for x in 0...@grid[y].length
        if x == 2 && y == 2
          @pending_new_grid[y] << '?'
          next
        end

        adjacent_bugs = num_adjacent_bugs(x, y)

        if @grid[y][x] == '.'
          @pending_new_grid[y] << ((adjacent_bugs == 1 || adjacent_bugs == 2) ? '#' : '.')
        else
          @pending_new_grid[y] << ((adjacent_bugs == 1) ? '#' : '.')
        end
      end
    end

    @child.game_of_life_step() if !@child.nil?
  end

  def apply_new_grid_state
    @grid = @pending_new_grid
    @pending_new_grid = []
    @child.apply_new_grid_state() if !@child.nil?
  end

  def print_grid
    puts "Depth: #{@depth}"
    puts @grid
    puts ""
    @child.print_grid() if !@child.nil?
  end

  def number_of_bugs
    bugs = 0

    for y in 0...@grid.length
      for x in 0...@grid[y].length
        bugs += 1 if bug_at_tile(x, y)
      end
    end

    bugs += @child.number_of_bugs() if !@child.nil?
    bugs
  end
end

def number_of_bugs_recursive(recursive_grid, minutes)
  for i in 0...minutes
    # Generates children and parents as necessary
    recursive_grid.generate_child()
    recursive_grid.generate_parent()

    top_level_grid = recursive_grid.get_top_level()
    top_level_grid.game_of_life_step()
    top_level_grid.apply_new_grid_state()
  end

  top_level_grid = recursive_grid.get_top_level()
  # top_level_grid.print_grid()
  top_level_grid.number_of_bugs()
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  grid = [
    '....#',
    '#..#.',
    '#..##',
    '..#..',
    '#....'
  ]
  puts(rating_of_first_repeat(grid))
end

def part_1_final()
  puts("PART 1 FINAL SOLUTION:")
  grid = [
    '..#.#',
    '.#.##',
    '...#.',
    '...##',
    '#.###'
  ]
  puts(rating_of_first_repeat(grid))
end

def part_2_example
  puts("PART 2 EXAMPLE SOLUTION")
  recursive_grid = RecursiveGrid.new(0, [
    '....#',
    '#..#.',
    '#.?##',
    '..#..',
    '#....'
  ])
  puts(number_of_bugs_recursive(recursive_grid, 10))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION")
  recursive_grid = RecursiveGrid.new(0, [
    '..#.#',
    '.#.##',
    '..?#.',
    '...##',
    '#.###'
  ])
  puts(number_of_bugs_recursive(recursive_grid, 200))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()