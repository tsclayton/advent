#!/usr/bin/env ruby

def dot_product(u, v)
  (u[0] * v[0]) + (u[1] * v[1])
end

def length(v)
  Math.sqrt(v[0].pow(2) + v[1].pow(2))
end

def distance(p1, p2)
  length(point_vector(p1, p2))
end

def point_vector(p1, p2)
  [p1[0] - p2[0], p1[1] - p2[1]]
end

def get_angle(u, v)
  angle = Math.acos(dot_product(u, v)/(length(u) * length(v)))

  if (v[0] < u[0])
    angle = (2 * Math::PI) - angle
  end

  angle
end

# Not quite normalization, but we want to reduce the vector to its smallest value so that the same vector doesn't get sorted differently due to float math
def normalize(v)
  common_factor = 1
  max_factor = [v[0].abs, v[1].abs].max

  for f in 1..max_factor
    if (v[0] % f) == 0 && (v[1] % f) == 0
      common_factor = f
    end
  end

  [v[0] / common_factor, v[1] / common_factor]
end

# Organizes asteroids by angle, then sorts them by distance to base
def get_ordered_asteroids(base_coords, asteroids)
  ordered_asteroids = {}

  asteroids.each do |asteroid|
    next if asteroid[0] == base_coords[0] && asteroid[1] == base_coords[1]

    vector = normalize(point_vector(asteroid, base_coords))
    angle = get_angle([0, -1], vector)
    ordered_asteroids[angle] ||= []
    ordered_asteroids[angle] << asteroid
  end

  ordered_asteroids.each do |angle, asteroid_list|
    asteroid_list.sort_by! { |asteroid| distance(base_coords, asteroid) }
  end

  ordered_asteroids
end

def get_asteroids_from_map(map)
  asteroids = []

  for y in 0...map.length
    for x in 0...map[y].length
      if map[y][x] == '#'
        asteroids << [x,y]
      end
    end
  end

  asteroids
end

def get_best_base(asteroids)
  asteroids_visible = 0
  best_coords = nil

  asteroids.each do |asteroid|
    ordered_asteroids = get_ordered_asteroids(asteroid, asteroids)
    if best_coords.nil? || ordered_asteroids.length > asteroids_visible
      asteroids_visible = ordered_asteroids.length
      best_coords = asteroid
    end
  end

  {coords: best_coords, asteroids_visible: asteroids_visible}
end

def get_vapourized_asteroid_coords(base_coords, asteroids, asteroid_number)
  ordered_asteroids = get_ordered_asteroids(base_coords, asteroids)
  ordered_asteroid_keys = ordered_asteroids.keys.sort
  asteroid = []

  while asteroid_number > 0
    ordered_asteroid_keys.each do |key|
      next if ordered_asteroids[key].nil? || ordered_asteroids[key].length == 0
      asteroid = ordered_asteroids[key].shift
      asteroid_number -= 1

      break if asteroid_number == 0
    end
  end

  (asteroid[0] * 100) + asteroid[1]
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  # The best location for a new monitoring station on this map is the highlighted asteroid at 3,4 because it can detect 8 asteroids
  puts(get_best_base(get_asteroids_from_map([
    ".#..#",
    ".....",
    "#####",
    "....#",
    "...##"])))
  # # Best is 5,8 with 33 other asteroids detected:
  puts(get_best_base(get_asteroids_from_map([
    "......#.#.",
    "#..#.#....",
    "..#######.",
    ".#.#.###..",
    ".#..#.....",
    "..#....#.#",
    "#..#....#.",
    ".##.#..###",
    "##...#..#.",
    ".#....####"])))
  # # Best is 1,2 with 35 other asteroids detected:
  puts(get_best_base(get_asteroids_from_map([
    "#.#...#.#.",
    ".###....#.",
    ".#....#...",
    "##.#.#.#.#",
    "....#.#.#.",
    ".##..###.#",
    "..#...##..",
    "..##....##",
    "......#...",
    ".####.###."])))
  # # Best is 6,3 with 41 other asteroids detected:
  puts(get_best_base(get_asteroids_from_map([
    ".#..#..###",
    "####.###.#",
    "....###.#.",
    "..###.##.#",
    "##.##.#.#.",
    "....###..#",
    "..#.#..#.#",
    "#..#.#.###",
    ".##...##.#",
    ".....#.#.."])))
  # # Best is 11,13 with 210 other asteroids detected:
  puts(get_best_base(get_asteroids_from_map([
    ".#..##.###...#######",
    "##.############..##.",
    ".#.######.########.#",
    ".###.#######.####.#.",
    "#####.##.#.##.###.##",
    "..#####..#.#########",
    "####################",
    "#.####....###.#.#.##",
    "##.#################",
    "#####.##.###..####..",
    "..######..##.#######",
    "####.##.####...##..#",
    ".#####..#.######.###",
    "##...#.##########...",
    "#.##########.#######",
    ".####.#.###.###.#.##",
    "....##.##.###..#####",
    ".#.#.###########.###",
    "#.#.#.#####.####.###",
    "###.##.####.##.#..##"])))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  asteroids = get_asteroids_from_map([
    ".#..##.###...#######",
    "##.############..##.",
    ".#.######.########.#",
    ".###.#######.####.#.",
    "#####.##.#.##.###.##",
    "..#####..#.#########",
    "####################",
    "#.####....###.#.#.##",
    "##.#################",
    "#####.##.###..####..",
    "..######..##.#######",
    "####.##.####...##..#",
    ".#####..#.######.###",
    "##...#.##########...",
    "#.##########.#######",
    ".####.#.###.###.#.##",
    "....##.##.###..#####",
    ".#.#.###########.###",
    "#.#.#.#####.####.###",
    "###.##.####.##.#..##"])
  puts(get_best_base(asteroids))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTION:")
  asteroids = get_asteroids_from_map([
    '.#....#####...#..',
    '##...##.#####..##',
    '##...#...#.#####.',
    '..#.....#...###..',
    '..#.#.....#....##'])
  best_base = get_best_base(asteroids)
  puts(get_vapourized_asteroid_coords(best_base[:coords], asteroids, 36))

  asteroids = get_asteroids_from_map([
    ".#..##.###...#######",
    "##.############..##.",
    ".#.######.########.#",
    ".###.#######.####.#.",
    "#####.##.#.##.###.##",
    "..#####..#.#########",
    "####################",
    "#.####....###.#.#.##",
    "##.#################",
    "#####.##.###..####..",
    "..######..##.#######",
    "####.##.####...##..#",
    ".#####..#.######.###",
    "##...#.##########...",
    "#.##########.#######",
    ".####.#.###.###.#.##",
    "....##.##.###..#####",
    ".#.#.###########.###",
    "#.#.#.#####.####.###",
    "###.##.####.##.#..##"])
  best_base = get_best_base(asteroids)
  puts(get_vapourized_asteroid_coords(best_base[:coords], asteroids, 200))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  asteroids = get_asteroids_from_map([
    '##.##..#.####...#.#.####',
    '##.###..##.#######..##..',
    '..######.###.#.##.######',
    '.#######.####.##.#.###.#',
    '..#...##.#.....#####..##',
    '#..###.#...#..###.#..#..',
    '###..#.##.####.#..##..##',
    '.##.##....###.#..#....#.',
    '########..#####..#######',
    '##..#..##.#..##.#.#.#..#',
    '##.#.##.######.#####....',
    '###.##...#.##...#.######',
    '###...##.####..##..#####',
    '##.#...#.#.....######.##',
    '.#...####..####.##...##.',
    '#.#########..###..#.####',
    '#.##..###.#.######.#####',
    '##..##.##...####.#...##.',
    '###...###.##.####.#.##..',
    '####.#.....###..#.####.#',
    '##.####..##.#.##..##.#.#',
    '#####..#...####..##..#.#',
    '.##.##.##...###.##...###',
    '..###.########.#.###..#.'])
  best_base = get_best_base(asteroids)
  puts(get_vapourized_asteroid_coords(best_base[:coords], asteroids, 200))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()
