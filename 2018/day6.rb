#!/usr/bin/env ruby

class Point
  attr_accessor :x
  attr_accessor :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

def get_points_from_file(filename)
  points = []

  point_id = 0
  File.open(filename, "r") do |file|
    file.each_line do |line|
      coords = line.gsub(/\s+/, '').split(',').map(&:to_i)
      points << Point.new(coords[0], coords[1])
      point_id += 1
    end
  end

  points
end

def distance(p1, p2)
  (p1.x - p2.x).abs + (p1.y - p2.y).abs
end

def get_bounding_box(points)
  min_x = min_y = max_x = max_y = nil

  points.each do |point|
    min_x = point.x if min_x.nil? || point.x < min_x
    min_y = point.y if min_y.nil? || point.y < min_y
    max_x = point.x if max_x.nil? || point.x > max_x
    max_y = point.y if max_y.nil? || point.y > max_y
  end

  [Point.new(min_x, min_y), Point.new(max_x, max_y)]
end

def get_largest_finite_area(points)
  bounds = get_bounding_box(points)
  min_bound = bounds[0]
  max_bound = bounds[1]

  # Using a hash because I don't feel like normalizing the coordinates.
  grid = {}

  for x in min_bound.x..max_bound.x
    grid[x] ||= {}

    for y in min_bound.y..max_bound.y
      grid[x][y] = nil
      is_tie = false
      min_distance = nil
      min_index = nil

      # 1 ... 2 ... 3 loops!
      points.each_with_index do |point, i|
        dist = distance(point, Point.new(x, y))
        if min_distance.nil? || dist < min_distance
          min_distance = dist
          min_index = i
          is_tie = false
        elsif min_distance == dist
          is_tie = true
        end
      end

      # -1 represents two points being equidistant
      grid[x][y] = (is_tie ? -1 : min_index)
    end
  end

  area_sizes = {}
  grid.values.each do |cols|
    cols.values.each do |cell|
      # don't include the in-betweeners
      if cell != -1
        area_sizes[cell] ||= 0
        area_sizes[cell] += 1
      end
    end
  end

  area_sizes.values.max
end

def get_safe_zone_area(points, min_distance_sum)
  bounds = get_bounding_box(points)
  min_bound = bounds[0]
  max_bound = bounds[1]

  safe_zone_area = 0

  for x in min_bound.x..max_bound.x
    for y in min_bound.y..max_bound.y
      distance_sum = 0

      points.each do |point|
        distance_sum += distance(point, Point.new(x, y))
      end

      safe_zone_area += 1 if distance_sum < min_distance_sum
    end
  end

  safe_zone_area
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = get_points_from_file("day6_example.txt")
  puts(get_largest_finite_area(example_input))
  puts("INPUT SOLUTION:")
  file_input = get_points_from_file("day6_input.txt")
  puts(get_largest_finite_area(file_input))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  example_input = get_points_from_file("day6_example.txt")
  puts(get_safe_zone_area(example_input, 32))
  puts("INPUT SOLUTION:")
  file_input = get_points_from_file("day6_input.txt")
  puts(get_safe_zone_area(file_input, 10000))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
