#!/usr/bin/env ruby

def get_triangles_from_file(filename)
  File.read(filename).split("\n").map do |line|
    line.scan(/[0-9]+/).map(&:to_i)
  end
end

def get_num_valid_trianges(triangles)
  valid_triangles = 0

  triangles.each do |triangle|
    triangle.sort!
    valid_triangles += 1 if triangle[0] + triangle[1] > triangle[2]
  end

  valid_triangles
end

def get_num_valid_trianges_vertical(triangles)
  valid_triangles = 0
  y = 0

  while y < triangles.length
    for x in 0...triangles[y].length
      vertical_triangle = [triangles[y][x], triangles[y + 1][x], triangles[y + 2][x]].sort
      valid_triangles += 1 if vertical_triangle[0] + vertical_triangle[1] > vertical_triangle[2]
    end
    
    y+= 3
  end

  valid_triangles
end


def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  puts(get_num_valid_trianges([[5, 10, 25]]))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  puts(get_num_valid_trianges(get_triangles_from_file('day3_input.txt')))
end

def part_2_example
  puts("PART 2 EXAMPLE SOLUTION:")
  input = [
    [101, 301, 501],
    [102, 302, 502],
    [103, 303, 503],
    [201, 401, 601],
    [202, 402, 602],
    [203, 403, 603]
  ]
  puts(get_num_valid_trianges_vertical(input))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  puts(get_num_valid_trianges_vertical(get_triangles_from_file('day3_input.txt')))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()
