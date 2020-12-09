#!/usr/bin/env ruby

def get_map_from_file(filename)
  map = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      map << line.gsub(/\s+/, '')
    end
  end

  map
end

def get_keys_from_map(map)
  keys = []

  map.each do |row|
    for i in 0...row.length
      # char is in the ascii range of a-z
      keys << row[i] if 97 <= row[i].ord && row[i].ord <= 122
    end
  end

  keys
end

def get_tile_position(map, tile)
  for y in 0...map.length
    for x in 0...map[y].length
      return [x, y] if map[y][x] == tile
    end
  end

  [-1, -1]
end

def get_tile(map, x, y)
  return nil if y < 0 || y >= map.length || x < 0 || x >= map[y].length

  map[y][x]
end

def keys_accessible_from_position(map, start_position)
  paths = {}

  queue = [start_position]
  distances = { start_position => 0 }
  keys_needed = { start_position => [] }

  while queue.length > 0
    position = queue.shift

    directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    directions.each do |direction|
      next_position = [position[0] + direction[0], position[1] + direction[1]]
      next_tile = get_tile(map, next_position[0], next_position[1])
      
      next if next_tile == '#'
      next if !distances[next_position].nil?

      next_keys_needed = keys_needed[position].clone
      next_distance = distances[position] + 1

      if !next_tile.match(/[A-Z]/).nil?
        next_keys_needed << next_tile.downcase
      elsif !next_tile.match(/[a-z]/).nil?
        paths[next_tile] = {keys_needed: next_keys_needed, distance: next_distance}
      end

      distances[next_position] = next_distance
      keys_needed[next_position] = next_keys_needed
      queue << next_position
    end
  end

  paths
end

def shortest_path_to_keys(map, paths, current_position, keys_left, current_keys, path_cache)
  path_cache_key = "#{current_position.join(',')}|#{current_keys.sort.join}"

  return path_cache[path_cache_key] if !path_cache[path_cache_key].nil?

  return 0 if keys_left.length == 0

  current_tile = get_tile(map, current_position[0], current_position[1])
  shortest_path = Float::INFINITY

  paths[current_tile].each do |next_key, key_info|
    if keys_left.member?(next_key) && (key_info[:keys_needed] - current_keys).length == 0
      next_position = get_tile_position(map, next_key)
      next_current_keys = (current_keys + [next_key]).sort
      next_keys_left = keys_left - [next_key]
      path_lengh = key_info[:distance] + shortest_path_to_keys(map, paths, next_position, next_keys_left, next_current_keys, path_cache)
      shortest_path = path_lengh if path_lengh < shortest_path
    end
  end

  path_cache[path_cache_key] = shortest_path
end

def get_shortest_path(map)
  keys = get_keys_from_map(map).sort

  path_points = ['@'] + keys

  paths = {}

  for i in 0...path_points.length
    start_tile = path_points[i]
    start_position = get_tile_position(map, start_tile)

    paths[start_tile] = keys_accessible_from_position(map, start_position)
  end

  shortest_path_to_keys(map, paths, get_tile_position(map, '@'), keys, [], {})
end

def quad_bot_shortest_path_to_keys(map, paths, bot_positions, keys_left, current_keys, path_cache)
  path_cache_key = "#{bot_positions.join(',')}|#{current_keys.sort.join}"

  return path_cache[path_cache_key] if !path_cache[path_cache_key].nil?

  return 0 if keys_left.length == 0

  shortest_path = Float::INFINITY

  for i in 0...bot_positions.length
    bot_position = bot_positions[i]
    current_tile = get_tile(map, bot_position[0], bot_position[1])

    paths[current_tile].each do |next_key, key_info|
      if keys_left.member?(next_key) && (key_info[:keys_needed] - current_keys).length == 0
        next_bot_positions = bot_positions.clone
        next_bot_positions[i] = get_tile_position(map, next_key)
        next_current_keys = (current_keys + [next_key]).sort
        next_keys_left = keys_left - [next_key]
        path_lengh = key_info[:distance] + quad_bot_shortest_path_to_keys(map, paths, next_bot_positions, next_keys_left, next_current_keys, path_cache)
        shortest_path = path_lengh if path_lengh < shortest_path
      end
    end
  end

  path_cache[path_cache_key] = shortest_path
end

def quad_bot_shortest_path(map)
  keys = get_keys_from_map(map).sort

  starting_positions = []
  # Set bots to different characters to differentiate in path map
  starting_tiles = ['@', '$', '%', '&']

  for y in 0...map.length
    for x in 0...map[y].length
      if map[y][x] == '@'
        map[y][x] = starting_tiles[starting_positions.length]
        starting_positions << [x, y]
      end
    end
  end

  paths = {}
  path_points = starting_tiles + keys

  for i in 0...path_points.length
    start_tile = path_points[i]
    start_position = get_tile_position(map, start_tile)

    paths[start_tile] = keys_accessible_from_position(map, start_position)
  end

  quad_bot_shortest_path_to_keys(map, paths, starting_positions, keys, [], {})
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  map = [
    '#########',
    '#b.A.@.a#',
    '#########'
  ]
  puts(get_shortest_path(map))

  map = [
    '########################',
    '#f.D.E.e.C.b.A.@.a.B.c.#',
    '######################.#',
    '#d.....................#',
    '########################'
  ]
  puts(get_shortest_path(map))

  map = [
    '########################',
    '#...............b.C.D.f#',
    '#.######################',
    '#.....@.a.B.c.d.A.e.F.g#',
    '########################'
  ]
  puts(get_shortest_path(map))

  map = [
    '#################',
    '#i.G..c...e..H.p#',
    '########.########',
    '#j.A..b...f..D.o#',
    '########@########',
    '#k.E..a...g..B.n#',
    '########.########',
    '#l.F..d...h..C.m#',
    '#################'
  ]
  puts(get_shortest_path(map))

  map = [
    '########################',
    '#@..............ac.GI.b#',
    '###d#e#f################',
    '###A#B#C################',
    '###g#h#i################',
    '########################'
  ]
  puts(get_shortest_path(map))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  map = get_map_from_file("day18_input.txt")
  puts(get_shortest_path(map))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  # 8 steps
  map = [
    '#######',
    '#a.#Cd#',
    '##@#@##',
    '#######',
    '##@#@##',
    '#cB#Ab#',
    '#######'
  ]
  puts(quad_bot_shortest_path(map))

  # 24 steps
  map = [
    '###############',
    '#d.ABC.#.....a#',
    '######@#@######',
    '###############',
    '######@#@######',
    '#b.....#.....c#',
    '###############'
  ]
  puts(quad_bot_shortest_path(map))

  # 32 steps
  map = [
    '#############',
    '#DcBa.#.GhKl#',
    '#.###@#@#I###',
    '#e#d#####j#k#',
    '###C#@#@###J#',
    '#fEbA.#.FgHi#',
    '#############'
  ]
  puts(quad_bot_shortest_path(map))

  map = [
    '#############',
    '#g#f.D#..h#l#',
    '#F###e#E###.#',
    '#dCba@#@BcIJ#',
    '#############',
    '#nK.L@#@G...#',
    '#M###N#H###.#',
    '#o#m..#i#jk.#',
    '#############'
  ]
  puts(quad_bot_shortest_path(map))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  map = get_map_from_file("day18_input.txt")
  old_start = get_tile_position(map, '@')
  map[old_start[1] - 1][(old_start[0] - 1)..(old_start[0] + 1)] = '@#@'
  map[old_start[1]][(old_start[0] - 1)..(old_start[0] + 1)] = '###'
  map[old_start[1] + 1][(old_start[0] - 1)..(old_start[0] + 1)] = '@#@'
  puts(quad_bot_shortest_path(map))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()
