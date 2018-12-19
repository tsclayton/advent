#!/usr/bin/env ruby

def get_area_from_file(filename)
  area = []

  y = 0

  File.open(filename, "r") do |file|
    file.each_line do |line|
      subbed_line = line.gsub(/\s+/, '')
      for x in 0...subbed_line.length
        area[x] ||= []
        area[x][y] = subbed_line[x]
      end

      y += 1
    end
  end

  area
end

def area_after_num_minutes(area, num_minutes)
  for min in 0...num_minutes
    new_area = []

    for x in 0...area.length
      new_area[x] ||= []

      for y in 0...area[x].length
        new_area[x][y] = area[x][y]

        x_min = [x - 1, 0].max
        x_max = [area.length - 1, x + 1].min

        y_min = [y - 1, 0].max
        y_max = [area[x].length - 1, y + 1].min

        adjacent_counts = {'.' => 0, '|' => 0, '#' => 0}
        for x_adj in x_min..x_max
          for y_adj in y_min..y_max
            next if x_adj == x && y_adj == y
            adjacent_counts[area[x_adj][y_adj]] += 1
          end
        end

        case area[x][y]
          when '.'
            new_area[x][y] = '|' if adjacent_counts['|'] >= 3
          when '|'
            new_area[x][y] = '#' if adjacent_counts['#'] >= 3
          when '#'
            new_area[x][y] = '.' if adjacent_counts['|'] == 0 || adjacent_counts['#'] == 0
        end
      end
    end

    area = new_area
  end

  area
end

def get_total_resource_value(area, num_minutes)
  new_area = area_after_num_minutes(area, num_minutes)
  num_trees = 0
  num_lumberyards = 0

  for x in 0...new_area.length
    for y in 0...new_area[x].length
      num_trees += 1 if new_area[x][y] == '|'
      num_lumberyards += 1 if new_area[x][y] == '#'
    end
  end

  # puts "num_trees = #{num_trees}, num_lumberyards = #{num_lumberyards} => value = #{num_trees * num_lumberyards}"
  num_trees * num_lumberyards
end

def get_resources(area, num_minutes)
  new_area = area_after_num_minutes(area, num_minutes)
  num_trees = 0
  num_lumberyards = 0

  for x in 0...new_area.length
    for y in 0...new_area[x].length
      num_trees += 1 if new_area[x][y] == '|'
      num_lumberyards += 1 if new_area[x][y] == '#'
    end
  end

  # puts "num_trees = #{num_trees}, num_lumberyards = #{num_lumberyards} => value = #{num_trees * num_lumberyards}"
  {num_trees: num_trees, num_lumberyards: num_lumberyards, value: num_trees * num_lumberyards}
end


def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = get_area_from_file("day18_example.txt")
  puts(get_total_resource_value(example_input, 10))

  puts("INPUT SOLUTION:")
  file_input = get_area_from_file("day18_input.txt")
  puts(get_total_resource_value(file_input, 10))
end


def part_2
  puts("INPUT SOLUTION:")
  # This one was another "mathy" solution. The pattern eventually starts oscillating around 478 and has a "wavelength" of 28.
  # Used that to determine that it's the same as the value at 524 minutes: 176782
  puts "176782"
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
