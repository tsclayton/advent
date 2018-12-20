#!/usr/bin/env ruby

def get_underground_from_file(filename)
  underground = {}

  File.open(filename, "r") do |file|
    file.each_line do |line|
      numbers = line.scan(/[0-9]+/).map(&:to_i)
      x_min = x_max = y_min = y_max = 0

      if line[0] == 'x'
        x_min = x_max = numbers[0]
        y_min = numbers[1]
        y_max = numbers[2]
      elsif line[0] == 'y'
        y_min = y_max = numbers[0]
        x_min = numbers[1]
        x_max = numbers[2]
      end

      for x in x_min..x_max
        underground[x] ||= {}

        for y in y_min..y_max
          # puts "#{x}, #{y} = #"
          underground[x][y] = '#'
        end
      end
    end
  end

  underground
end

def num_tiles_reached_by_water(underground)
  water_tiles = get_water_tiles(underground)
  water_tiles['|'] + water_tiles['~']
end

def get_water_tiles(underground)
  y_min = y_max = nil

  underground.values.each do |col|
    col.keys.each do |y|
      y_min = y if y_min.nil? || y < y_min
      y_max = y.to_i if y_max.nil? || y.to_i > y_max
    end
  end

  fill_up_underground(underground, y_min, y_max, [500, 0])

  water_tiles = {'|' => 0, '~' => 0}

  underground.values.each do |col|
    for y in y_min..y_max
      water_tiles['|'] += 1 if col[y] == '|'
      water_tiles['~'] += 1 if col[y] == '~'
    end
  end

  water_tiles
end

def get_tile(underground, x, y)
  return '.' if underground[x].nil? || underground[x][y].nil?

  underground[x][y]
end

def set_tile(underground, x, y, tile)
  underground[x] ||= {}
  underground[x][y] = tile
end

def fill_up_underground(underground, y_min, y_max, spring_position)
  water_coords = spring_position.clone()

  while water_coords[1] <= y_max
    set_tile(underground, water_coords[0], water_coords[1], '|')
    tile_below = get_tile(underground, water_coords[0], water_coords[1] + 1)

    if tile_below == '.'
      # Sand below, keep going down
      water_coords[1] += 1
    elsif tile_below == '#' || tile_below == '~'
      # spread out
      while true
        #spread to the left
        left_wall_x = nil
        left_x = water_coords[0] - 1

        while true
          underground[left_x] ||= {}

          if get_tile(underground, left_x, water_coords[1]) == '#' || get_tile(underground, left_x, water_coords[1]) == '~'
            left_wall_x = left_x
            break
          elsif get_tile(underground, left_x, water_coords[1] + 1) == '.'
            fill_up_underground(underground, y_min, y_max, [left_x, water_coords[1]])
            # if you totally filled up a basin below, keep spreading, otherwise break
            break if get_tile(underground, left_x, water_coords[1] + 1) == '|'
          else
            set_tile(underground, left_x, water_coords[1], '|')
          end

          left_x -= 1
        end

        #spread to the right
        right_wall_x = nil
        right_x = water_coords[0] + 1

        while true
          underground[right_x] ||= {}

          if get_tile(underground, right_x, water_coords[1]) == '#' || get_tile(underground, right_x, water_coords[1]) == '~'
            right_wall_x = right_x
            break
          elsif get_tile(underground, right_x, water_coords[1] + 1) == '.'
            fill_up_underground(underground, y_min, y_max, [right_x, water_coords[1]])
            # if you totally filled up a basin below, keep spreading, otherwise break
            break if get_tile(underground, right_x, water_coords[1] + 1) == '|'
          else
            set_tile(underground, right_x, water_coords[1], '|')
          end

          right_x += 1
        end

        if !left_wall_x.nil? && !right_wall_x.nil?
          # Mark water non-running
          for x in (left_wall_x + 1)..(right_wall_x - 1)
            set_tile(underground, x, water_coords[1], '~')
          end

          # fill up to next row
          water_coords[1] -= 1
          # if we've filled up to water above, we're done with this iteration
          return if get_tile(underground, water_coords[0], water_coords[1]) == '~'
          set_tile(underground, water_coords[0], water_coords[1], '|')
        else
          return
        end
      end
    else
      break
    end
  end
end

def print_underground(underground)
  x_min = x_max = y_min = y_max = nil

  x_min = underground.keys.min
  x_max = underground.keys.max

  underground.values.each do |col|
    col.keys.each do |y|
      y_min = y if y_min.nil? || y < y_min
      y_max = y.to_i if y_max.nil? || y.to_i > y_max
    end
  end

  for y in y_min..y_max
    str = ''
    for x in x_min..x_max
      str << get_tile(underground, x, y)
    end
    puts str
  end
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = get_underground_from_file("day17_example.txt")
  puts(num_tiles_reached_by_water(example_input))

  puts("INPUT SOLUTION:")
  file_input = get_underground_from_file("day17_input.txt")
  puts(num_tiles_reached_by_water(file_input))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  example_input = get_underground_from_file("day17_example.txt")
  puts(get_water_tiles(example_input)['~'])

  puts("INPUT SOLUTION:")
  file_input = get_underground_from_file("day17_input.txt")
  puts(get_water_tiles(file_input)['~'])
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
