#!/usr/bin/env ruby

def get_map_from_file(filename)
  map = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      map << line.gsub(/\n/, '')
    end
  end

  map
end

def scan_map(map)
  start_position = [-1, -1]
  end_position = [-1, -1]
  portals = {}

  seen_portals = {}

  # Too lazy to do this in a cleverer way
  for y in 2...(map.length - 2)
    for x in 2...(map[y].length - 2)
      next if map[y][x] != '.'

      portal = nil
      if !map[y - 2][x].match(/[A-Z]/).nil? && !map[y - 1][x].match(/[A-Z]/).nil?
        portal = {name: map[y - 2][x] + map[y - 1][x], entrance: [x, y - 1], exit: [x, y]}
      elsif !map[y + 2][x].match(/[A-Z]/).nil? && !map[y + 1][x].match(/[A-Z]/).nil?
        portal = {name: map[y + 1][x] + map[y + 2][x], entrance: [x, y + 1], exit: [x, y]}
      elsif !map[y][x + 2].match(/[A-Z]/).nil? && !map[y][x + 1].match(/[A-Z]/).nil?
        portal = {name: map[y][x + 1] + map[y][x + 2], entrance: [x + 1, y], exit: [x, y]}
      elsif !map[y][x - 2].match(/[A-Z]/).nil? && !map[y][x - 1].match(/[A-Z]/).nil?
        portal = {name: map[y][x - 2] + map[y][x - 1], entrance: [x - 1, y], exit: [x, y]}
      end

      if !portal.nil?
        if portal[:name] == 'AA'
          start_position = [x, y]
        elsif portal[:name] == 'ZZ'
            end_position = [x, y]
        elsif !seen_portals[portal[:name]].nil?
          # link 'em up!
          portals[seen_portals[portal[:name]][:entrance]] = portal[:exit]
          portals[portal[:entrance]] = seen_portals[portal[:name]][:exit]
        else
          seen_portals[portal[:name]] = portal
        end
      end
    end
  end

  {start_position: start_position, end_position: end_position, portals: portals}
end

def distance(p1, p2)
  (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs
end

def get_next_positions(map, portals, position, end_position, previous_cells)
  directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]

  next_positions = []

  directions.each do |direction|
    next_position = [position[0] + direction[0], position[1] + direction[1]]

    next if map[next_position[1]][next_position[0]] == '#' || previous_cells[next_position]

    if !map[next_position[1]][next_position[0]].match(/[A-Z]/).nil? && !portals[next_position].nil?
      next_positions << portals[next_position] if previous_cells[portals[next_position]].nil?
    elsif map[next_position[1]][next_position[0]] == '.'
      next_positions << next_position
    end
  end

  next_positions.sort_by {|pos| distance(pos, end_position)}
end

def shortest_path_to_end(map, portals, position, end_position, previous_cells, depth, current_shortest_path)
  return depth if position == end_position

  return Float::INFINITY if depth >= current_shortest_path

  next_previous_cells = previous_cells.clone
  next_previous_cells[position] = true

  next_positions = get_next_positions(map, portals, position, end_position, previous_cells)

  next_positions.each do |next_position|
    path_length = shortest_path_to_end(map, portals, next_position, end_position, next_previous_cells, depth + 1, current_shortest_path)
    current_shortest_path = path_length if path_length < current_shortest_path
  end

  current_shortest_path
end

def shortest_path(map)
  map_scan = scan_map(map)
  shortest_path_to_end(map, map_scan[:portals], map_scan[:start_position], map_scan[:end_position], {}, 0, Float::INFINITY)
end

# Don't want to have to edit my part 1 to accomodate my wacky ideas for part 2
# Considering my final solution, I definitely could've formatted the data better
def scan_recursive_map(map)
  start_position = [-1, -1]
  end_position = [-1, -1]
  portals = {}

  seen_portals = {}

  # Still too lazy to do this in a cleverer way
  for y in 2...(map.length - 2)
    for x in 2...(map[y].length - 2)
      next if map[y][x] != '.'

      # use z access to denote the recursive layer a portal transports to
      exit_z = (x == 2 || x == map[y].length - 3 || y == 2 || y == map.length - 3) ? -1 : 1

      portal = nil
      if !map[y - 2][x].match(/[A-Z]/).nil? && !map[y - 1][x].match(/[A-Z]/).nil?
        portal = {name: map[y - 2][x] + map[y - 1][x], entrance: [x, y - 1], exit: [x, y, exit_z]}
      elsif !map[y + 2][x].match(/[A-Z]/).nil? && !map[y + 1][x].match(/[A-Z]/).nil?
        portal = {name: map[y + 1][x] + map[y + 2][x], entrance: [x, y + 1], exit: [x, y, exit_z]}
      elsif !map[y][x + 2].match(/[A-Z]/).nil? && !map[y][x + 1].match(/[A-Z]/).nil?
        portal = {name: map[y][x + 1] + map[y][x + 2], entrance: [x + 1, y], exit: [x, y, exit_z]}
      elsif !map[y][x - 2].match(/[A-Z]/).nil? && !map[y][x - 1].match(/[A-Z]/).nil?
        portal = {name: map[y][x - 2] + map[y][x - 1], entrance: [x - 1, y], exit: [x, y, exit_z]}
      end

      if !portal.nil?
        if portal[:name] == 'AA'
          start_position = [x, y, 0]
        elsif portal[:name] == 'ZZ'
            end_position = [x, y, 0]
        elsif !seen_portals[portal[:name]].nil?
          # link 'em up!
          portals[seen_portals[portal[:name]][:entrance]] = portal[:exit]
          portals[portal[:entrance]] = seen_portals[portal[:name]][:exit]
        else
          seen_portals[portal[:name]] = portal
        end
      end
    end
  end

  {start_position: start_position, end_position: end_position, portals: portals}
end

def shortest_same_level_path(map, point_a, point_b, previous_cells, depth, current_shortest_path)
  return depth if point_a[0..1] == point_b[0..1]

  return Float::INFINITY if depth >= current_shortest_path

  next_previous_cells = previous_cells.clone
  next_previous_cells[point_a] = true

  next_positions = [[1, 0], [-1, 0], [0, 1], [0, -1]].map {|dir| [point_a[0] + dir[0], point_a[1] + dir[1]]}.sort_by  {|pos| distance(pos, point_b)}

  next_positions.each do |next_position|
    next if next_position[1] < 0 || next_position[1] >= map.length || next_position[0] < 0 || next_position[0] >= map[next_position[1]].length
    next if previous_cells[next_position] || map[next_position[1]][next_position[0]].match(/[\.A-Z]/).nil?

    path_length = shortest_same_level_path(map, next_position, point_b, next_previous_cells, depth + 1, current_shortest_path)
    current_shortest_path = path_length if path_length < current_shortest_path
  end

  current_shortest_path
end

def get_shortest_paths_between_points(map, portals, start_position, end_position)
  paths = {start_position[0..1] => {}}

  start_to_end = shortest_same_level_path(map, start_position, end_position, {}, 0, Float::INFINITY)
  paths[start_position[0..1]][end_position] = start_to_end if start_to_end < Float::INFINITY

  # This is a very messy way of doing this, but I'm tired of this problem
  for i in 0...portals.keys.length
    portal_a_entrance = portals.keys[i]
    portal_a_exit = portals[portals.keys[i]]

    paths[portal_a_exit[0..1]] ||= {}

    for j in 0...portals.keys.length
      next if i == j

      portal_b_entrance = portals.keys[j]
      portal_b_exit = portals[portals.keys[j]]

      a_to_b = shortest_same_level_path(map, portal_a_exit, portal_b_entrance, {}, 0, Float::INFINITY)
      # A path of 1 means going from a portal's exit to its entrance
      if a_to_b < Float::INFINITY && a_to_b != 1
        paths[portal_a_exit[0..1]][portal_b_exit] = a_to_b
      end
    end

    start_to_portal = shortest_same_level_path(map, start_position, portal_a_entrance, {}, 0, Float::INFINITY)
    paths[start_position[0..1]][portal_a_exit] = start_to_portal if start_to_portal < Float::INFINITY

    portal_to_end = shortest_same_level_path(map, portal_a_exit, end_position, {}, 0, Float::INFINITY)
    paths[portal_a_exit[0..1]][end_position] = portal_to_end if portal_to_end < Float::INFINITY
  end

  paths
end

# DFS is my favourite naïve approach, but it literally goes too deep
def breadth_of_the_wild(map, paths, start_position, end_position)
  current_shortest_path = Float::INFINITY

  distances = { start_position => 0}
  queue = [start_position]

  while queue.length > 0
    position = queue.shift

    next if paths[position[0..1]].nil?

    paths[position[0..1]].each do |new_position, distance|
      next_position = [new_position[0], new_position[1], new_position[2] + position[2]]
      next_distance = distances[position] + distance

      # Can't go up when at the top level
      next if next_position[2] > 0

      if next_position == end_position
        return next_distance if next_distance < current_shortest_path
      else
        distances[next_position] ||= Float::INFINITY
        # Might be possible to get somewhere faster using different portals. Check this just in case
        distances[next_position] = [next_distance, distances[next_position]].min
        queue << next_position
      end
    end
  end

  current_shortest_path
end

def shortest_recursive_path(map)
  map_scan = scan_recursive_map(map)
  paths = get_shortest_paths_between_points(map, map_scan[:portals], map_scan[:start_position], map_scan[:end_position])
  breadth_of_the_wild(map, paths, map_scan[:start_position], map_scan[:end_position])
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  map = [
    '         A           ',
    '         A           ',
    '  #######.#########  ',
    '  #######.........#  ',
    '  #######.#######.#  ',
    '  #######.#######.#  ',
    '  #######.#######.#  ',
    '  #####  B    ###.#  ',
    'BC...##  C    ###.#  ',
    '  ##.##       ###.#  ',
    '  ##...DE  F  ###.#  ',
    '  #####    G  ###.#  ',
    '  #########.#####.#  ',
    'DE..#######...###.#  ',
    '  #.#########.###.#  ',
    'FG..#########.....#  ',
    '  ###########.#####  ',
    '             Z       ',
    '             Z       '
  ]
  puts(shortest_path(map))

  map = [
    '                   A               ',
    '                   A               ',
    '  #################.#############  ',
    '  #.#...#...................#.#.#  ',
    '  #.#.#.###.###.###.#########.#.#  ',
    '  #.#.#.......#...#.....#.#.#...#  ',
    '  #.#########.###.#####.#.#.###.#  ',
    '  #.............#.#.....#.......#  ',
    '  ###.###########.###.#####.#.#.#  ',
    '  #.....#        A   C    #.#.#.#  ',
    '  #######        S   P    #####.#  ',
    '  #.#...#                 #......VT',
    '  #.#.#.#                 #.#####  ',
    '  #...#.#               YN....#.#  ',
    '  #.###.#                 #####.#  ',
    'DI....#.#                 #.....#  ',
    '  #####.#                 #.###.#  ',
    'ZZ......#               QG....#..AS',
    '  ###.###                 #######  ',
    'JO..#.#.#                 #.....#  ',
    '  #.#.#.#                 ###.#.#  ',
    '  #...#..DI             BU....#..LF',
    '  #####.#                 #.#####  ',
    'YN......#               VT..#....QG',
    '  #.###.#                 #.###.#  ',
    '  #.#...#                 #.....#  ',
    '  ###.###    J L     J    #.#.###  ',
    '  #.....#    O F     P    #.#...#  ',
    '  #.###.#####.#.#####.#####.###.#  ',
    '  #...#.#.#...#.....#.....#.#...#  ',
    '  #.#####.###.###.#.#.#########.#  ',
    '  #...#.#.....#...#.#.#.#.....#.#  ',
    '  #.###.#####.###.###.#.#.#######  ',
    '  #.#.........#...#.............#  ',
    '  #########.###.###.#############  ',
    '           B   J   C               ',
    '           U   P   P               '
  ]
  puts(shortest_path(map))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  map = get_map_from_file("day20_input.txt")
  puts(shortest_path(map))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
    map = [
    '         A           ',
    '         A           ',
    '  #######.#########  ',
    '  #######.........#  ',
    '  #######.#######.#  ',
    '  #######.#######.#  ',
    '  #######.#######.#  ',
    '  #####  B    ###.#  ',
    'BC...##  C    ###.#  ',
    '  ##.##       ###.#  ',
    '  ##...DE  F  ###.#  ',
    '  #####    G  ###.#  ',
    '  #########.#####.#  ',
    'DE..#######...###.#  ',
    '  #.#########.###.#  ',
    'FG..#########.....#  ',
    '  ###########.#####  ',
    '             Z       ',
    '             Z       '
  ]
  puts(shortest_recursive_path(map))

  map = [
    '             Z L X W       C                 ',
    '             Z P Q B       K                 ',
    '  ###########.#.#.#.#######.###############  ',
    '  #...#.......#.#.......#.#.......#.#.#...#  ',
    '  ###.#.#.#.#.#.#.#.###.#.#.#######.#.#.###  ',
    '  #.#...#.#.#...#.#.#...#...#...#.#.......#  ',
    '  #.###.#######.###.###.#.###.###.#.#######  ',
    '  #...#.......#.#...#...#.............#...#  ',
    '  #.#########.#######.#.#######.#######.###  ',
    '  #...#.#    F       R I       Z    #.#.#.#  ',
    '  #.###.#    D       E C       H    #.#.#.#  ',
    '  #.#...#                           #...#.#  ',
    '  #.###.#                           #.###.#  ',
    '  #.#....OA                       WB..#.#..ZH',
    '  #.###.#                           #.#.#.#  ',
    'CJ......#                           #.....#  ',
    '  #######                           #######  ',
    '  #.#....CK                         #......IC',
    '  #.###.#                           #.###.#  ',
    '  #.....#                           #...#.#  ',
    '  ###.###                           #.#.#.#  ',
    'XF....#.#                         RF..#.#.#  ',
    '  #####.#                           #######  ',
    '  #......CJ                       NM..#...#  ',
    '  ###.#.#                           #.###.#  ',
    'RE....#.#                           #......RF',
    '  ###.###        X   X       L      #.#.#.#  ',
    '  #.....#        F   Q       P      #.#.#.#  ',
    '  ###.###########.###.#######.#########.###  ',
    '  #.....#...#.....#.......#...#.....#.#...#  ',
    '  #####.#.###.#######.#######.###.###.#.#.#  ',
    '  #.......#.......#.#.#.#.#...#...#...#.#.#  ',
    '  #####.###.#####.#.#.#.#.###.###.#.###.###  ',
    '  #.......#.....#.#...#...............#...#  ',
    '  #############.#.#.###.###################  ',
    '               A O F   N                     ',
    '               A A D   M                     '
  ]
  puts(shortest_recursive_path(map))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  map = get_map_from_file("day20_input.txt")
  puts(shortest_recursive_path(map))
end


part_1_examples()
part_1_final()
part_2_examples()
part_2_final()