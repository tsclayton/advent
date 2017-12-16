#!/usr/bin/env ruby

# Coords should progress like this:
# [0,0], [1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1], [0,-1], [1,-1],
# [2,-1], [2, 0], [2, 1], [2,2], [1,2], [0,2], [-1,2], [-2,2], [-2,1], [-2,0], [-2,-1], [-2,-2], [-1,-2], [0,-2], [1,-2], [2,-2]
# [3,-2] ...

def get_coordinates(square)
  coords = [0, 0]
  # index of coords currently being incremented
  direction = 0
  incrementor = square_radius = 1

  for i in 1...square
    coords[direction] += incrementor

    if coords[0] == square_radius && coords[1] == -square_radius
      square_radius += 1
    end

    if coords[direction].abs == square_radius
      if direction == 0
        # x limit reached, go y with the same incrementor
        direction = 1
      elsif direction == 1
        # y limit reached, go x with the opposite incrementor
        direction = 0
        incrementor *= -1
      end
    end
  end

  return coords
end

def get_distance_from_centre(square)
  coords = get_coordinates(square)
  coords[0].abs + coords[1].abs
end

def part_1
  puts("EXAMPLE SOLUTIONS:")
  puts(get_distance_from_centre(1))
  puts(get_distance_from_centre(12))
  puts(get_distance_from_centre(23))
  puts(get_distance_from_centre(1024))
  puts("INPUT SOLUTION:")
  puts(get_distance_from_centre(368078))
end

class Cell
  neighbours = []

end

# hacks all the way down!
# Retrospect: Instead of searching through list, could convert coords into string and store cells in hash for constant time lookup
def get_neighbours(coords, cells)
  neighbours = []
  cells.each do |cell|
    if (coords[0] - cell[:coords][0]).abs <= 1 && (coords[1] - cell[:coords][1]).abs <= 1
      neighbours << cell
    end
  end

  return neighbours
end

def get_first_cell_with_value_greater_than(max_value)
  coords = [0, 0]
  direction = 0
  incrementor = square_radius = 1
  cells = [{coords: [0,0], value: 1}]

  while true
    coords[direction] += incrementor

    if coords[0] == square_radius && coords[1] == -square_radius
      square_radius += 1
    end

    if coords[direction].abs == square_radius
      if direction == 0
        # x limit reached, go y with the same incrementor
        direction = 1
      elsif direction == 1
        # y limit reached, go x with the opposite incrementor
        direction = 0
        incrementor *= -1
      end
    end

    neighbours = get_neighbours(coords, cells)

    value = neighbours.inject(0) { |a, b| a + b[:value] }
    cell = {coords: [coords[0], coords[1]], value: value}
    cells << cell

    if max_value != nil && value > max_value
      break
    end
  end

  # return value of last cell generated
  return cells[-1][:value]
end

def part_2
  puts("INPUT SOLUTION:")
  puts(get_first_cell_with_value_greater_than(368078))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
