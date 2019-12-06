#!/usr/bin/env ruby

def get_orbits_from_file(filename)
  orbits = {}

  point_id = 0
  File.open(filename, "r") do |file|
    file.each_line do |line|
      split_line = line.gsub(/\s+/, '').split(')')
      orbitee = split_line[0]
      orbiter = split_line[1]

      orbits[orbitee] ||= []
      orbits[orbitee] << orbiter
    end
  end

  orbits
end

def orbit_checksum(orbits, orbiter, depth)
  total = depth

  if orbits[orbiter]
    orbits[orbiter].each do |orbitee|
      total += orbit_checksum(orbits, orbitee, depth + 1)
    end
  end

  total
end

def path_to_orbiter(orbits, orbiter, target, curr_path)
  if orbiter == target
    return curr_path
  end

  if orbits[orbiter]
    orbits[orbiter].each do |orbitee|
      path = path_to_orbiter(orbits, orbitee, target, curr_path + [orbiter])
      return path if !path.nil?
    end
  end

  nil
end

def quickest_path_to_santa(orbits, orbiter)
  path_to_you = path_to_orbiter(orbits, orbiter, "YOU", [])
  path_to_santa = path_to_orbiter(orbits, orbiter, "SAN", [])

  if (path_to_you.nil? || path_to_santa.nil?)
    # common path impossible
    return - 1
  end

  # subtract common root + 1 extra to get moves between nodes
  path_length = path_to_you.length + path_to_santa.length - 2

  if orbits[orbiter]
    orbits[orbiter].each do |orbitee|
      sub_path_length = quickest_path_to_santa(orbits, orbitee)
      if sub_path_length > 0 && sub_path_length < path_length
        path_length = sub_path_length
      end
    end
  end

  path_length
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  example_input = get_orbits_from_file("day6_example.txt")
  puts(orbit_checksum(example_input, "COM", 0))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  puzzle_input = get_orbits_from_file("day6_input.txt")
  puts(orbit_checksum(puzzle_input, "COM", 0))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  example_input = get_orbits_from_file("day6_example.txt")
  example_input["K"] = ["YOU"]
  example_input["I"] = ["SAN"]
  puts(quickest_path_to_santa(example_input, "COM"))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  puzzle_input = get_orbits_from_file("day6_input.txt")
  puts(quickest_path_to_santa(puzzle_input, "COM"))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()