#!/usr/bin/env ruby

def parse_directions(str)
  split_str = str.split(', ')

  split_str.map do |s|
    {turn: s[0], num_blocks: s[1...s.length].to_i}
  end
end

def distance_after_directions(directions)
  orientation = [0, 1]
  location = [0, 0]

  directions.each do |direction|
    if direction[:turn] == 'R'
      orientation = [orientation[1], -orientation[0]]
    elsif direction[:turn] == 'L'
      orientation = [-orientation[1], orientation[0]]
    end

    location[0] += (orientation[0] * direction[:num_blocks])
    location[1] += (orientation[1] * direction[:num_blocks])
  end

  location.map(&:abs).sum
end

def first_location_visited_twice(directions)
  orientation = [0, 1]
  location = [0, 0]

  visited_locations = {location.to_s => true}

  directions.each do |direction|
    if direction[:turn] == 'R'
      orientation = [orientation[1], -orientation[0]]
    elsif direction[:turn] == 'L'
      orientation = [-orientation[1], orientation[0]]
    end

    for i in 0...direction[:num_blocks]
      location[0] += orientation[0]
      location[1] += orientation[1]

      if visited_locations[location.to_s].nil?
        visited_locations[location.to_s] = true
      else
        return location.map(&:abs).sum
      end
    end
  end

  puts "no location visited twice"
  location.map(&:abs).sum
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  puts(distance_after_directions(parse_directions("R2, L3")))
  puts(distance_after_directions(parse_directions("R2, R2, R2")))
  puts(distance_after_directions(parse_directions("R5, L5, R5, R3")))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  puts(distance_after_directions(parse_directions("L3, R2, L5, R1, L1, L2, L2, R1, R5, R1, L1, L2, R2, R4, L4, L3, L3, R5, L1, R3, L5, L2, R4, L5, R4, R2, L2, L1, R1, L3, L3, R2, R1, L4, L1, L1, R4, R5, R1, L2, L1, R188, R4, L3, R54, L4, R4, R74, R2, L4, R185, R1, R3, R5, L2, L3, R1, L1, L3, R3, R2, L3, L4, R1, L3, L5, L2, R2, L1, R2, R1, L4, R5, R4, L5, L5, L4, R5, R4, L5, L3, R4, R1, L5, L4, L3, R5, L5, L2, L4, R4, R4, R2, L1, L3, L2, R5, R4, L5, R1, R2, R5, L2, R4, R5, L2, L3, R3, L4, R3, L2, R1, R4, L5, R1, L5, L3, R4, L2, L2, L5, L5, R5, R2, L5, R1, L3, L2, L2, R3, L3, L4, R2, R3, L1, R2, L5, L3, R4, L4, R4, R3, L3, R1, L3, R5, L5, R1, R5, R3, L1")))
end

def part_2_example
  puts("PART 2 EXAMPLE SOLUTION:")
  puts(first_location_visited_twice(parse_directions("R8, R4, R4, R8")))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  puts(first_location_visited_twice(parse_directions("L3, R2, L5, R1, L1, L2, L2, R1, R5, R1, L1, L2, R2, R4, L4, L3, L3, R5, L1, R3, L5, L2, R4, L5, R4, R2, L2, L1, R1, L3, L3, R2, R1, L4, L1, L1, R4, R5, R1, L2, L1, R188, R4, L3, R54, L4, R4, R74, R2, L4, R185, R1, R3, R5, L2, L3, R1, L1, L3, R3, R2, L3, L4, R1, L3, L5, L2, R2, L1, R2, R1, L4, R5, R4, L5, L5, L4, R5, R4, L5, L3, R4, R1, L5, L4, L3, R5, L5, L2, L4, R4, R4, R2, L1, L3, L2, R5, R4, L5, R1, R2, R5, L2, R4, R5, L2, L3, R3, L4, R3, L2, R1, R4, L5, R1, L5, L3, R4, L2, L2, L5, L5, R5, R2, L5, R1, L3, L2, L2, R3, L3, L4, R2, R3, L1, R2, L5, L3, R4, L4, R4, R3, L3, R1, L3, R5, L5, R1, R5, R3, L1")))
end

part_1_examples()
part_1_final()
part_2_example()
part_2_final()