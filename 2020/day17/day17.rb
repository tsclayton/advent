#!/usr/bin/env ruby

def get_neighbours(coords, is_4d)
  neighbours = []

  for dx in -1..1
    for dy in -1..1
      for dz in -1..1
        if is_4d
          # Hey, DW!
          for dw in -1..1
            next if dx == 0 && dy == 0 && dz == 0 && dw == 0
            neighbours << [coords[0] + dx, coords[1] + dy, coords[2] + dz, coords[3] + dw]
          end
        else
          next if dx == 0 && dy == 0 && dz == 0
          neighbours << [coords[0] + dx, coords[1] + dy, coords[2] + dz, 0]
        end
      end
    end
  end

  neighbours
end

def game_of_life(state, is_4d)
  outer_coords = []
  state.keys.each do |coords|
    outer_coords += get_neighbours(coords, is_4d)
  end

  new_state = {}
  coords_to_check = new_state.keys

  outer_coords.each do |coords|
    coords_to_check << coords
  end

  coords_to_check.each do |coords|
    next if !new_state[coords].nil?

    was_active = state[coords]
    is_active = false

    neighbours = get_neighbours(coords, is_4d)
    
    active_neighbours = 0

    neighbours.each do |neighbour|
      active_neighbours += 1 if state[neighbour] == true
    end

    is_active = true if was_active && (active_neighbours == 2 || active_neighbours == 3)
    is_active = true if !was_active && active_neighbours == 3

    # State is the same mirrored across 3rd and 4th dimensions
    mirror_coords = [[coords[0], coords[1], coords[2], coords[3]], [coords[0], coords[1], -coords[2], coords[3]], [coords[0], coords[1], coords[2], -coords[3]], [coords[0], coords[1], -coords[2], -coords[3]]]
    mirror_coords.each do |mirror_coord|
      new_state[mirror_coord] = is_active
    end
  end

  new_state.delete_if {|key, value| !value}

  new_state
end

def active_tiles_after_iterations(initial_state, iterations, is_4d)
  state = {}

  for y in 0...initial_state.length
    for x in 0...initial_state[y].length
      state[[x, y, 0, 0]] = true if initial_state[y][x] == '#'
    end
  end

  for i in 0...iterations
    state = game_of_life(state, is_4d)
  end

  state.values.map {|v| v ? 1 : 0}.sum
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  initial_state = [
    '.#.',
    '..#',
    '###'
  ]
  puts(active_tiles_after_iterations(initial_state, 6, false))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  initial_state = [
    '.#.#.#..',
    '..#....#',
    '#####..#',
    '#####..#',
    '#####..#',
    '###..#.#',
    '#..##.##',
    '#.#.####'
  ]
  puts(active_tiles_after_iterations(initial_state, 6, false))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  initial_state = [
    '.#.',
    '..#',
    '###'
  ]
  puts(active_tiles_after_iterations(initial_state, 6, true))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  initial_state = [
    '.#.#.#..',
    '..#....#',
    '#####..#',
    '#####..#',
    '#####..#',
    '###..#.#',
    '#..##.##',
    '#.#.####'
  ]
  puts(active_tiles_after_iterations(initial_state, 6, true))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()
