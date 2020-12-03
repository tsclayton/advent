#!/usr/bin/env ruby

def get_map_from_file(filename)
  map = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      map << line.gsub(/[\s+]+/, '')
    end
  end

  map
end

def trees_in_path(map, slope_x, slope_y)
  num_trees = 0
  position = [0, 0]

  while position[1] < map.length
    num_trees += 1 if map[position[1]][position[0]] == '#'
    position[0] = (position[0] + slope_x) % map[position[0]].length
    position[1] += slope_y
  end

  num_trees
end

def multi_slope_tree_product(map)
  slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
  slopes.map {|slope| trees_in_path(map, slope[0], slope[1])}.reduce(:*)
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  map = [
    '..##.......',
    '#...#...#..',
    '.#....#..#.',
    '..#.#...#.#',
    '.#...##..#.',
    '..#.##.....',
    '.#.#.#....#',
    '.#........#',
    '#.##...#...',
    '#...##....#',
    '.#..#...#.#'
  ]
  puts(trees_in_path(map, 3, 1))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  puts(trees_in_path(get_map_from_file("day3_input.txt"), 3, 1))
end

def part_2_example
  puts("PART 2 EXAMPLE SOLUTION:")
  map = [
    '..##.......',
    '#...#...#..',
    '.#....#..#.',
    '..#.#...#.#',
    '.#...##..#.',
    '..#.##.....',
    '.#.#.#....#',
    '.#........#',
    '#.##...#...',
    '#...##....#',
    '.#..#...#.#'
  ]
  puts(multi_slope_tree_product(map))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  puts(multi_slope_tree_product(get_map_from_file("day3_input.txt")))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()
