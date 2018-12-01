#!/usr/bin/env ruby

# Code from day10.rb with slight tweaks
def generate_sparse_hash(numbers, lengths, iterations)
  skip_size = 0
  curr_index = 0

  (1..iterations).each do |iteration|
    lengths.each do |length|
      start_index = curr_index
      end_index = curr_index + length - 1

      while start_index < end_index
        # swap numbers
        temp = numbers[start_index % numbers.length]
        numbers[start_index % numbers.length] = numbers[end_index % numbers.length]
        numbers[end_index % numbers.length] = temp

        start_index += 1
        end_index -= 1
      end

      curr_index = (curr_index + length + skip_size) % numbers.length

      skip_size += 1
    end
  end

  numbers
end

def generate_dense_hash(sparse_hash)
  sparse_hash.each_slice(16).map {|partition| partition.reduce(&:^)}
end

# Might as well convert right to binary instead of converting to hex first
def convert_to_binary_string(dense_hash)
  dense_hash.map do |part|
    binary_part = part.to_s(2)
    # append leading 0s if necessary
    leading_zeros = '0' * (8 - binary_part.length)
    leading_zeros + binary_part
  end.join('')
end

def knot_hash(input)
  ascii_input = input.each_char.map(&:ord)
  numbers = (0..255).to_a
  generate_sparse_hash(numbers, ascii_input + [17, 31, 73, 47, 23], 64)
  dense_hash = generate_dense_hash(numbers)
  convert_to_binary_string(dense_hash)
end

def generate_grid(input)
  grid = []

  for i in 0..127
    kh = knot_hash("#{input}-#{i}")
    grid[i] = kh.each_char.map {|char| char == '1'}
  end

  grid
end

def num_used_squares(input)
  grid = generate_grid(input)

  used_count = 0

  grid.each do |row|
    row.each do |column|
      used_count += 1 if column
    end
  end

  used_count
end

def mark_regions(grid, regions, row, col)
  # return if cell not used or already marked
  return unless grid[row][col] && !regions[row][col]

  regions[row][col] = true

  # Left
  mark_regions(grid, regions, row - 1, col) if (row - 1) >= 0
  # Right
  mark_regions(grid, regions, row + 1, col) if (row + 1) < grid.length
  # Up
  mark_regions(grid, regions, row, col - 1) if (col - 1) >= 0
  # Down
  mark_regions(grid, regions, row, col + 1) if (col + 1) < grid[row].length
end

def num_regions(input)
  grid = generate_grid(input)
  regions = []

  region_count = 0

  for row in 0...grid.length do
    regions[row] = Array.new(grid[row].length, false)
  end

  for row in 0...grid.length do
    for col in 0...grid[row].length do
      if grid[row][col] && !regions[row][col]
        # new region, increment counter and recursively mark all adjacent cells
        region_count += 1
        mark_regions(grid, regions, row, col)
      end
    end
  end

  region_count
end

def part_1
  puts("EXAMPLE SOLUTION:")
  puts(num_used_squares('flqrgnkx'))
  puts("INPUT SOLUTION:")
  puts(num_used_squares('wenycdww'))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  puts(num_regions('flqrgnkx'))
  puts("INPUT SOLUTION:")
  puts(num_regions('wenycdww'))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
