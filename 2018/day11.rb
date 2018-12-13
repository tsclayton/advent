#!/usr/bin/env ruby

def initialize_power_grid(serial_number)
  grid = []

  for x in 0...300
    grid[x] ||= []

    for y in 0...300
      grid[x][y] = get_power_level(x, y, serial_number)
    end
  end

  grid
end

def get_power_level(x, y, serial_number)
  rack_id = x + 10

  power_level = (rack_id * y + serial_number) * rack_id
  power_level = (power_level / 100) % 10

  power_level - 5
end

def get_largest_power_square(power_grid)
  largest_power_coords = [0, 0]
  largest_power = -1000

  for x in 0...298
    for y in 0...298
      power_sum = power_grid[x][y] + power_grid[x + 1][y] + power_grid[x + 2][y] +
                    power_grid[x][y + 1] + power_grid[x + 1][y + 1] + power_grid[x + 2][y + 1] +
                    power_grid[x][y + 2] + power_grid[x + 1][y + 2] + power_grid[x + 2][y + 2]

      if power_sum > largest_power
        largest_power_coords = [x, y]
        largest_power = power_sum
      end
    end
  end

  largest_power_coords.join(',')
end

def get_largest_variable_power_square(power_grid, square_size)
  largest_power_coords = [0, 0]
  largest_power = -1000

  for x in 0...(298 - square_size + 1)
    for y in 0...(298 - square_size + 1)
      power_sum = 0

      for ix in 0...square_size
        for iy in 0...square_size
          power_sum += power_grid[x + ix][y + iy]
        end
      end

      if power_sum > largest_power
        largest_power_coords = [x, y]
        largest_power = power_sum
      end
    end
  end

  {coords: largest_power_coords, power: largest_power}
end

def shitty_largest_power_square_of_any_size(power_grid)
  largest_power = -1000
  largest_power_coords = []
  largest_power_size = 0

  # for size in 1..300
  max_bad_streak = 3
  current_streak = 0
  for size in 1..300
  # for size in 13..100
    results = get_largest_variable_power_square(power_grid, size)

    if results[:power] >= largest_power
      current_streak = 0
      largest_power = results[:power]
      largest_power_coords = results[:coords]
      largest_power_size = size
    else
      # if the max power is negative, we're probably not gonna make it any bigger by increasing the size
      break if results[:power] < 0
    end
  end

  "#{largest_power_coords[0]},#{largest_power_coords[1]},#{largest_power_size}"
end

def part_1
  puts("EXAMPLE SOLUTIONS:")
  puts(get_largest_power_square(initialize_power_grid(18)))
  puts(get_largest_power_square(initialize_power_grid(42)))

  puts("INPUT SOLUTION:")
  puts(get_largest_power_square(initialize_power_grid(8199)))
end

# You discover a dial on the side of the device; it seems to let you select a square of any size, not just 3x3. Sizes from 1x1 to 300x300 are supported.

# Realizing this, you now must find the square of any size with the largest total power. Identify this square by including its size as a third parameter after the top-left coordinate: a 9x9 square with a top-left corner of 3,5 is identified as 3,5,9.

# For example:

# For grid serial number 18, the largest total square (with a total power of 113) is 16x16 and has a top-left corner of 90,269, so its identifier is 90,269,16.
# For grid serial number 42, the largest total square (with a total power of 119) is 12x12 and has a top-left corner of 232,251, so its identifier is 232,251,12.
# What is the X,Y,size identifier of the square with the largest total power?

def part_2
  puts("EXAMPLE SOLUTIONS:")
  # puts(shitty_largest_power_square_of_any_size(initialize_power_grid(18)))
  # 90,269,16
  # puts(shitty_largest_power_square_of_any_size(initialize_power_grid(42)))
  # 232,251,12
  puts("INPUT SOLUTION:")
  puts(shitty_largest_power_square_of_any_size(initialize_power_grid(8199)))
  # 235,271,13
  # size: 18, power: 119
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
