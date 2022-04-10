#!/usr/bin/env ruby

def get_map_from_file(filename)
  File.read(filename).split("\n")
end

def shortest_path(map, return_to_start = false)
  start_pos = nil
  pois = []

  for y in 0...map.length
    for x in 0...map[y].length
      if map[y][x] == '0'
        start_pos = [x, y]
      elsif map[y][x].to_i > 0
        pois << map[y][x].to_i
      end
    end
  end

  pois += [0] if return_to_start

  start_state = {pos: start_pos, pois: []}

  distances = {start_state => 0}
  state_queue = [start_state]

  while !state_queue.empty?
    state = state_queue.shift
    distance = distances[state]

    return distance if state[:pois].length == pois.length

    next_posns = []

    [[1, 0], [0, 1], [-1, 0], [0, -1]].each do |dir|
      next_pos = [state[:pos][0] + dir[0], state[:pos][1] + dir[1]]
      next_posns << next_pos if next_pos[0] >= 0 && next_pos[1] >= 0
    end

    next_posns.each do |next_pos|
      next_tile = map[next_pos[1]][next_pos[0]]

      next if next_tile == '#'

      next_pois = state[:pois].clone
      if next_tile.to_i > 0 && !next_pois.member?(next_tile.to_i)
        next_pois += [next_tile.to_i]
      elsif return_to_start && next_tile == '0' && next_pois.length == pois.length - 1
        next_pois += [0]
      end

      next_state = {pos: next_pos, pois: next_pois}
      if distances[next_state].nil?
        state_queue << next_state
        distances[next_state] = distance + 1
      end
    end
  end

  0
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  map = [
    '###########',
    '#0.1.....2#',
    '#.#######.#',
    '#4.......3#',
    '###########'
  ]
  puts(shortest_path(map))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  map = get_map_from_file('day24_input.txt')
  puts(shortest_path(map))
end

def part_2_example
  puts('PART 1 EXAMPLE SOLUTION:')
  map = [
    '###########',
    '#0.1.....2#',
    '#.#######.#',
    '#4.......3#',
    '###########'
  ]
  puts(shortest_path(map, true))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  map = get_map_from_file('day24_input.txt')
  puts(shortest_path(map, true))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()
