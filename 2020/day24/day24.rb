#!/usr/bin/env ruby

def get_tile_directions_from_file(filename)
  get_tile_directions_from_strings(File.read(filename).split("\n"))
end

def get_tile_directions_from_strings(lines)
  tile_directions = []

  lines.each do |line|
    directions = []
    line_chars = line.chars

    while !line_chars.empty?
      direction = line_chars.shift
      if direction == 'n' || direction == 's'
        direction += line_chars.shift
      end

      directions << direction.to_sym
    end

    tile_directions << directions
  end

  tile_directions
end

def colour_tiles(tile_directions)
  coloured_tiles = {}

  tile_directions.each do |directions|
    position = [0, 0]

    directions.each do |direction|
      case direction
      when :ne
        position = [position[0] + 0.5, position[1] + 1]
      when :nw
        position = [position[0] - 0.5, position[1] + 1]
      when :se
        position = [position[0] + 0.5, position[1] - 1]
      when :sw
        position = [position[0] - 0.5, position[1] - 1]
      when :e
        position[0] += 1
      when :w
        position[0] -= 1
      end
    end

    coloured_tiles[position] ||= false
    coloured_tiles[position] = !coloured_tiles[position]
  end

  coloured_tiles
end

def coloured_tile_count(tile_directions)
  coloured_tiles = colour_tiles(tile_directions)
  coloured_tiles.values.count(true)
end

def get_neighbours(coords)
  [
    [coords[0] + 0.5, coords[1] + 1],
    [coords[0] - 0.5, coords[1] + 1],
    [coords[0] + 0.5, coords[1] - 1],
    [coords[0] - 0.5, coords[1] - 1],
    [coords[0] + 1, coords[1]],
    [coords[0] - 1, coords[1]]
  ]
end

def game_of_tiles(tile_directions, rounds)
  coloured_tiles = colour_tiles(tile_directions)

  for round in 0...rounds
    new_coloured_tiles = coloured_tiles.clone

    coloured_tiles.delete_if {|key, value| !value}

    tiles_to_check = []

    coloured_tiles.each do |coords, value|
      tiles_to_check << coords
      tiles_to_check += get_neighbours(coords)
    end

    tiles_to_check.uniq

    tiles_to_check.each do |tile|
      neighbours = get_neighbours(tile)
      coloured_neighbour_count = 0

      neighbours.each do |neighbour|
        coloured_neighbour_count += 1 if coloured_tiles[neighbour]
        break if coloured_neighbour_count > 2
      end

      if coloured_tiles[tile] && (coloured_neighbour_count == 0 || coloured_neighbour_count > 2)
        new_coloured_tiles[tile] = false
      elsif !coloured_tiles[tile] && coloured_neighbour_count == 2
        new_coloured_tiles[tile] = true
      end
    end

    coloured_tiles = new_coloured_tiles
  end

  coloured_tiles.values.count(true)
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  tile_directions = get_tile_directions_from_strings([
    'sesenwnenenewseeswwswswwnenewsewsw',
    'neeenesenwnwwswnenewnwwsewnenwseswesw',
    'seswneswswsenwwnwse',
    'nwnwneseeswswnenewneswwnewseswneseene',
    'swweswneswnenwsewnwneneseenw',
    'eesenwseswswnenwswnwnwsewwnwsene',
    'sewnenenenesenwsewnenwwwse',
    'wenwwweseeeweswwwnwwe',
    'wsweesenenewnwwnwsenewsenwwsesesenwne',
    'neeswseenwwswnwswswnw',
    'nenwswwsewswnenenewsenwsenwnesesenew',
    'enewnwewneswsewnwswenweswnenwsenwsw',
    'sweneswneswneneenwnewenewwneswswnese',
    'swwesenesewenwneswnwwneseswwne',
    'enesenwswwswneneswsenwnewswseenwsese',
    'wnwnesenesenenwwnenwsewesewsesesew',
    'nenewswnwewswnenesenwnesewesw',
    'eneswnwswnwsenenwnwnwwseeswneewsenese',
    'neswnwewnwnwseenwseesewsenwsweewe',
    'wseweeenwnesenwwwswnew',
  ])
  puts "#{tile_directions}"
  puts(coloured_tile_count(tile_directions))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  tile_directions = get_tile_directions_from_file('day24_input.txt')
  puts(coloured_tile_count(tile_directions))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  tile_directions = get_tile_directions_from_strings([
    'sesenwnenenewseeswwswswwnenewsewsw',
    'neeenesenwnwwswnenewnwwsewnenwseswesw',
    'seswneswswsenwwnwse',
    'nwnwneseeswswnenewneswwnewseswneseene',
    'swweswneswnenwsewnwneneseenw',
    'eesenwseswswnenwswnwnwsewwnwsene',
    'sewnenenenesenwsewnenwwwse',
    'wenwwweseeeweswwwnwwe',
    'wsweesenenewnwwnwsenewsenwwsesesenwne',
    'neeswseenwwswnwswswnw',
    'nenwswwsewswnenenewsenwsenwnesesenew',
    'enewnwewneswsewnwswenweswnenwsenwsw',
    'sweneswneswneneenwnewenewwneswswnese',
    'swwesenesewenwneswnwwneseswwne',
    'enesenwswwswneneswsenwnewswseenwsese',
    'wnwnesenesenenwwnenwsewesewsesesew',
    'nenewswnwewswnenesenwnesewesw',
    'eneswnwswnwsenenwnwnwwseeswneewsenese',
    'neswnwewnwnwseenwseesewsenwsweewe',
    'wseweeenwnesenwwwswnew',
  ])
  puts(game_of_tiles(tile_directions, 100))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  tile_directions = get_tile_directions_from_file('day24_input.txt')
  puts(game_of_tiles(tile_directions, 100))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()
