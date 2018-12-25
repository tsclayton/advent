#!/usr/bin/env ruby

class Point
  attr_accessor :coords
  attr_accessor :neighbours

  def initialize(coords)
    @coords = coords
    @neighbours = []
  end
end

def get_points_from_file(filename)
  points = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      points << Point.new(line.scan(/-?[0-9]+/).map(&:to_i))
    end
  end

  points
end

def distance(point_a, point_b)
  distance = 0

  for i in 0...point_a.coords.length
    distance += (point_a.coords[i] - point_b.coords[i]).abs
  end

  distance
end

def traverse_constellation(point, hit_points)
  return if !hit_points[point.coords.join(',')].nil?
  hit_points[point.coords.join(',')] = true

  point.neighbours.each do |neighbour|
    traverse_constellation(neighbour, hit_points)
  end
end

def get_num_constellations(points)
  points.each_with_index do |point_a, i|
    points.each_with_index do |point_b, j|
      next if i == j
      if distance(point_a, point_b) <= 3
        point_a.neighbours << point_b
        point_b.neighbours << point_a
      end
    end
  end

  num_constellations = 0
  hit_points = {}

  points.each do |point|
    next if !hit_points[point.coords.join(',')].nil?
    traverse_constellation(point, hit_points)
    num_constellations += 1
  end

  num_constellations
end

def part_1
  puts("EXAMPLE SOLUTIONS:")
  example_1_points = [
    Point.new([0,0,0,0]),
    Point.new([3,0,0,0]),
    Point.new([0,3,0,0]),
    Point.new([0,0,3,0]),
    Point.new([0,0,0,3]),
    Point.new([0,0,0,6]),
    Point.new([9,0,0,0]),
    Point.new([12,0,0,0])
  ]
  puts(get_num_constellations(example_1_points))

  example_2_points = [
    Point.new([-1,2,2,0]),
    Point.new([0,0,2,-2]),
    Point.new([0,0,0,-2]),
    Point.new([-1,2,0,0]),
    Point.new([-2,-2,-2,2]),
    Point.new([3,0,2,-1]),
    Point.new([-1,3,2,2]),
    Point.new([-1,0,-1,0]),
    Point.new([0,2,1,-2]),
    Point.new([3,0,0,0]),
  ]
  puts(get_num_constellations(example_2_points))

  example_3_points = [
    Point.new([1,-1,0,1]),
    Point.new([2,0,-1,0]),
    Point.new([3,2,-1,0]),
    Point.new([0,0,3,1]),
    Point.new([0,0,-1,-1]),
    Point.new([2,3,-2,0]),
    Point.new([-2,2,0,0]),
    Point.new([2,-2,0,-1]),
    Point.new([1,-1,0,-1]),
    Point.new([3,2,0,2])
  ]
  puts(get_num_constellations(example_3_points))

  example_4_points = [
    Point.new([1,-1,-1,-2]),
    Point.new([-2,-2,0,1]),
    Point.new([0,2,1,3]),
    Point.new([-2,3,-2,1]),
    Point.new([0,2,3,-2]),
    Point.new([-1,-1,1,-2]),
    Point.new([0,-2,-1,0]),
    Point.new([-2,2,3,-1]),
    Point.new([1,2,2,0]),
    Point.new([-1,-2,0,-2])
  ]

  puts(get_num_constellations(example_4_points))

  puts("INPUT SOLUTION:")
  file_input = get_points_from_file("day25_input.txt")
  puts(get_num_constellations(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
