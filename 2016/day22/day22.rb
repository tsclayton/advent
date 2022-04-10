#!/usr/bin/env ruby

def get_nodes_from_strings(strings)
  nodes = []

  strings.each do |line|
    next if !line.match(/(root|Filesystem)/).nil?

    split_line = line.split("\ ")
    pos = split_line[0].scan(/[0-9]+/).map(&:to_i)
    total_space = split_line[1].match(/[0-9]+/).to_s.to_i
    space_used = split_line[2].match(/[0-9]+/).to_s.to_i

    nodes << {pos: pos, total_space: total_space, space_used: space_used}
  end

  nodes
end

def get_nodes_from_file(filename)
  get_nodes_from_strings(File.read(filename).split("\n"))
end

def is_viable_pair(a, b)
  a[:space_used] != 0 && a[:pos] != b[:pos] && a[:space_used] <= (b[:total_space] - b[:space_used])
end

def num_viable_pairs(nodes)
  num_pairs = 0

  for i in 0...nodes.length
    for j in 0...nodes.length
      num_pairs += 1 if is_viable_pair(nodes[i], nodes[j])
    end
  end

  num_pairs
end

def print_map(nodes, wall_threshold)
  num_steps = 0

  grid = []

  nodes.each do |node|
    grid[node[:pos][1]] ||= []
    grid[node[:pos][1]][node[:pos][0]] = node
  end

  for y in 0...grid.length
    row_str = ''

    for x in 0...grid[y].length
      node_char = '.'
      if grid[y][x][:space_used] == 0
        node_char = '_'
      elsif grid[y][x][:space_used] >= wall_threshold
        node_char = '#'
      elsif y == 0 && x == 0
        node_char = '*'
      elsif y == 0 && x == grid[y].length - 1
        node_char = 'G'
      end

      row_str << node_char
    end

    puts row_str
  end
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  nodes = get_nodes_from_file('day22_input.txt')
  puts(num_viable_pairs(nodes))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  nodes = get_nodes_from_strings([
    'Filesystem            Size  Used  Avail  Use%',
    '/dev/grid/node-x0-y0   10T    8T     2T   80%',
    '/dev/grid/node-x0-y1   11T    6T     5T   54%',
    '/dev/grid/node-x0-y2   32T   28T     4T   87%',
    '/dev/grid/node-x1-y0    9T    7T     2T   77%',
    '/dev/grid/node-x1-y1    8T    0T     8T    0%',
    '/dev/grid/node-x1-y2   11T    7T     4T   63%',
    '/dev/grid/node-x2-y0   10T    6T     4T   60%',
    '/dev/grid/node-x2-y1    9T    8T     1T   88%',
    '/dev/grid/node-x2-y2    9T    6T     3T   66%'
  ])

  print_map(nodes, 25)
  # 1 up, 1 right, 1 5-shuffle
  puts(1 + 1 + (1 * 5))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  nodes = get_nodes_from_file('day22_input.txt')
  print_map(nodes, 400)
  puts(3 + 6 + 3 + 22 + (5 * 35))
end

part_1_final()
part_2_example()
part_2_final()