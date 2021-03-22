#!/usr/bin/env ruby

def get_tiles_from_file(filename)
  tiles = {}
  current_tile_num = nil
  current_tile = []

  File.read(filename).split("\n").each do |line|
    if !line.match(/[0-9]+/).nil?
      if !current_tile_num.nil?
        tiles[current_tile_num] = current_tile
      end

      current_tile_num = line.match(/[0-9]+/).to_s.to_i
      current_tile = []
    elsif line.length > 0
      current_tile << line
    end
  end

  tiles[current_tile_num] = current_tile

  tiles
end

def get_sides(tile)
  sides = ['', '', '', '']

  # piece is a square
  for s in 0...tile.length
    sides[0] << tile[s][0]
    sides[1] << tile[s][tile.length - 1]
    sides[2] << tile[0][s]
    sides[3] << tile[tile.length - 1][s]
  end

  sides
end

def connects(side_1, side_2)
  side_1 == side_2 || side_1.reverse == side_2
end

def get_corners(tiles)
  corners = []

  tiles.each do |tile_id, tile|
    tile_1_sides = get_sides(tile)
    connecting_sides = 0

    tiles.each do |tile_id_2, tile_2|
      next if tile_id == tile_id_2

      tile_2_sides = get_sides(tile_2)

      tile_1_sides.each do |tile_1_side|
        tile_2_sides.each do |tile_2_side|
          connecting_sides += 1 if connects(tile_1_side, tile_2_side)
        end
      end
    end

    if connecting_sides == 2
      corners << tile_id
    end
  end

  corners
end

def get_tile_orientations(tile)
  orientations = [tile]

  current_rotation = tile

  for i in 0...3
    rotation = []
    for x in 0...current_rotation[0].length
      rotation_row = ''

      for y in 0...current_rotation.length
        rotation_row << current_rotation[current_rotation.length - 1 - y][x]
      end

      rotation << rotation_row
    end

    orientations << rotation
    current_rotation = rotation
  end

  for i in 0...2
    flip_base = orientations[i]
    orientations << flip_base.reverse
    orientations << flip_base.map {|row| row.reverse}
  end

  orientations
end

# Has connection where tile a is on the left and tile b is on the right
def connects_horizontally(tile_a, tile_b)
  connects = true

  for y in 0...tile_a.length
    if tile_a[y][-1] != tile_b[y][0]
      connects = false
      break
    end
  end

  connects
end

# Has connection where tile a is omn the top and tile b is on the bottom
def connects_vertically(tile_a, tile_b)
  connects = true

  for x in 0...tile_a[0].length
    if tile_a[-1][x] != tile_b[0][x]
      connects = false
      break
    end
  end

  connects
end

def assemble_puzzle(tiles, corners)
  starting_corner = tiles[corners[0]]
  size = Math.sqrt(tiles.length).floor

  # Orient starting corner so it has a connection to its right and on its bottom
  starting_corner_orientations = get_tile_orientations(starting_corner)
  potential_starting_orientations = []

  starting_corner_orientations.each do |starting_corner_orientation|
    has_bottom_connection = false
    has_side_connection = false

    tiles.each do |tile_id, tile|
      tile_orientations = get_tile_orientations(tile)

      tile_orientations.each do |orientation|
        if !has_side_connection && connects_horizontally(starting_corner_orientation, orientation)
          has_side_connection = true
          break
        elsif !has_bottom_connection && connects_vertically(starting_corner_orientation, orientation)
          has_bottom_connection = true
          break
        end
      end

      break if has_side_connection && has_bottom_connection
    end

    if has_side_connection && has_bottom_connection
      # There can be more than one orientation that can act as a corner but only one is correct
      potential_starting_orientations << starting_corner_orientation
    end
  end

  potential_starting_orientations.each do |starting_corner_orientation|
    puzzle = []
    current_tile = nil
    checking_horizontal = true
    remaining_tiles = tiles.clone
    invalid_puzzle = false

    for y in 0...size
      puzzle_row = []

      for x in 0...size
        if x == 0
          if y == 0
            current_tile = starting_corner_orientation
            remaining_tiles.delete(corners[0])
            puzzle_row << current_tile
            next
          end

          current_tile = puzzle[y - 1][0]
          checking_horizontal = false
        else
          checking_horizontal = true
        end
          
        connecting_tile = nil

        remaining_tiles.each do |tile_id, tile|
          orientations = get_tile_orientations(tile)
          orientations.each do |orientation|
            connects = checking_horizontal ? connects_horizontally(current_tile, orientation) : connects_vertically(current_tile, orientation)

            if connects
              connecting_tile = orientation
              break
            end
          end

          if !connecting_tile.nil?
            remaining_tiles.delete(tile_id)
            current_tile = connecting_tile
            puzzle_row << connecting_tile
            break
          end
        end

        if connecting_tile.nil?
          invalid_puzzle = true
          break
        end
      end

      break if invalid_puzzle
      puzzle << puzzle_row
    end

    return puzzle if !invalid_puzzle
  end

  nil
end

def remove_borders(piece)
  new_piece = []

  for y in 1...(piece.length - 1)
    row = ''

    for x in 1...(piece[y].length - 1)
      row << piece[y][x]
    end

    new_piece << row
  end

  new_piece
end

def get_image(puzzle)
  for row in 0...puzzle.length
    for col in 0...puzzle[row].length
      puzzle[row][col] = remove_borders(puzzle[row][col])
    end
  end

  image = []

  for row in 0...puzzle.length
    for y in 0...puzzle[0][0].length
      image_row = ''

      for col in 0...puzzle[row].length
        for x in 0...puzzle[row][col][y].length
          image_row << puzzle[row][col][y][x]
        end
      end

      image << image_row
    end
  end

  image
end

def count_sea_monsters(image)
  num_sea_monsters = 0
  sea_monster_offsets = [
    [-1, -1], 
    [0, 0], [-1, 0], [-2, 0], [-7, 0], [-8, 0], [-13, 0], [-14, 0], [-19, 0],
    [-3, 1], [-6, 1], [-9, 1], [-12, 1], [-15, 1], [-18, 1]
  ]

  image_orientation = get_tile_orientations(image)

  num_sea_monsters = 0

  image_orientation.each do |image_orientation|
    num_sea_monsters = 0

    for y in 1...(image_orientation.length - 1)
      for x in 19...image_orientation[y].length
        has_sea_monster = true

        sea_monster_offsets.each do |offset|
          has_sea_monster = false if image_orientation[y + offset[1]][x + offset[0]] == '.'
          break if !has_sea_monster
        end

        num_sea_monsters += 1 if has_sea_monster
      end
    end

    break if num_sea_monsters > 0
  end

  total_black_count = image.map {|row| row.count('#')}.sum
  total_black_count - (num_sea_monsters * 15)
end

def get_sea_monsters_from_tiles(tiles)
  corners = get_corners(tiles)
  puzzle = assemble_puzzle(tiles, corners)
  image = get_image(puzzle)
  count_sea_monsters(image)
end

def corner_product(tiles)
  get_corners(tiles).reduce(:*)
end

def part_1_examples
  puts('PART 1 EXAMPLE SOLUTIONS:')
  puts(corner_product(get_tiles_from_file('day20_example.txt')))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  puts(corner_product(get_tiles_from_file('day20_input.txt')))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  puts(get_sea_monsters_from_tiles(get_tiles_from_file('day20_example.txt')))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  puts(get_sea_monsters_from_tiles(get_tiles_from_file('day20_input.txt')))
end

part_1_examples()
part_1_final()
part_2_example()
part_2_final()
