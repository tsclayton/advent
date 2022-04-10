#!/usr/bin/env ruby

class Unit
  attr_accessor :pos
  attr_accessor :health
  attr_accessor :attack
  attr_accessor :is_elf

  def initialize(pos, health, attack, is_elf)
    @pos = pos
    @health = health
    @attack = attack
    @is_elf = is_elf
  end
end

def get_units_from_map(map, elf_attack = 3)
  units = []

  for y in 0...map.length
    for x in 0...map[y].length
      if map[y][x] == 'E' || map[y][x] == 'G'
        is_elf = map[y][x] == 'E'
        attack = is_elf ? elf_attack : 3
        units << Unit.new([x, y], 200, attack, is_elf)
      end
    end
  end

  units
end

def turn_order_sort(units)
  units.sort_by! {|u| u.pos.reverse}
end

def get_adjacent_target(unit, targets)
  adjacent_spaces = [[unit.pos[0], unit.pos[1] - 1], [unit.pos[0] - 1, unit.pos[1]], [unit.pos[0] + 1, unit.pos[1]], [unit.pos[0], unit.pos[1] + 1]]
  weakest_target = nil

  targets.sort_by {|t| t.pos.reverse}.each do |target|
    if adjacent_spaces.member?(target.pos) && (weakest_target.nil? || target.health < weakest_target.health)
      weakest_target = target
    end
  end

  weakest_target
end

def get_open_adjacent_spaces(space, map)
  spaces = []

  directions = [[0, -1], [-1, 0], [1, 0], [0, 1]]

  directions.each do |direction|
    adjacent_space = [space[0] + direction[0], space[1] + direction[1]]

    spaces << adjacent_space if map[adjacent_space[1]][adjacent_space[0]] == '.'
  end

  spaces
end

def get_spaces_adjacent_to_targets(targets, map)
  open_adjacent_spaces = []

  targets.map do |target|
    open_adjacent_spaces += get_open_adjacent_spaces(target.pos, map)
  end

  open_adjacent_spaces.uniq
end

def get_space_to_move_to(unit, target_adjacent_spaces, map)
  distances = {}
  distances[unit.pos] = 0

  queue = [unit.pos]

  while !queue.empty?
    space = queue.shift
    next_cost = distances[space] + 1
    get_open_adjacent_spaces(space, map).each do |next_space|
      next if !distances[next_space].nil? && distances[next_space] <= next_cost
      distances[next_space] = next_cost
      queue.push(next_space)
    end
  end

  best_space = nil

  target_adjacent_spaces.sort_by(&:reverse).each do |target_adjacent_space|
    next if distances[target_adjacent_space].nil?

    if best_space.nil? || distances[target_adjacent_space] < distances[best_space]
      best_space = target_adjacent_space
    end
  end

  return nil if best_space.nil?

  distances = {}
  distances[best_space] = 0

  queue = [best_space]

  while !queue.empty?
    space = queue.shift
    next_cost = distances[space] + 1
    get_open_adjacent_spaces(space, map).each do |next_space|
      next if !distances[next_space].nil? && distances[next_space] <= next_cost
      distances[next_space] = next_cost
      queue.push(next_space)
    end
  end

  spaces_adjacent_to_unit = get_open_adjacent_spaces(unit.pos, map)

  space_to_move_to = nil

  spaces_adjacent_to_unit.each do |space|
    next if distances[space].nil?

    if space_to_move_to.nil? || distances[space] < distances[space_to_move_to]
      space_to_move_to = space
    end
  end

  space_to_move_to
end

def print_state(map, units, total_rounds)
  puts ""
  puts "After #{total_rounds} rounds:"
  puts map
  puts "Remaining Units:"

  units.each do |unit|
    unit_type = unit.is_elf ? 'E' : 'G'
    puts "#{unit_type} @ #{unit.pos}: #{unit.health}"
  end
end

def run_combat(map, elf_attack = 3)
  units = get_units_from_map(map, elf_attack)
  combat_over = false
  total_rounds = 0
  elf_lost = false

  while true
    units = turn_order_sort(units)

    units.each do |unit|
      next if unit.health <= 0

      targets = units.filter {|t| t.is_elf == !unit.is_elf && t.health > 0}

      if targets.empty?
        combat_over = true
        break
      end

      adjacent_target = get_adjacent_target(unit, targets)

      if adjacent_target.nil?
        target_adjacent_spaces = get_spaces_adjacent_to_targets(targets, map)

        next if target_adjacent_spaces.empty?

        space_to_move_to = get_space_to_move_to(unit, target_adjacent_spaces, map)

        if !space_to_move_to.nil?
          map[unit.pos[1]][unit.pos[0]] = '.'
          unit.pos[0] = space_to_move_to[0]
          unit.pos[1] = space_to_move_to[1]
          map[unit.pos[1]][unit.pos[0]] = unit.is_elf ? 'E' : 'G'

          adjacent_target = get_adjacent_target(unit, targets)
        end
      end

      # Target in range, attack
      if !adjacent_target.nil?
        adjacent_target.health -= unit.attack

        if adjacent_target.health <= 0
          map[adjacent_target.pos[1]][adjacent_target.pos[0]] = '.'
          elf_lost = true if adjacent_target.is_elf
        end
      end
    end

    units.delete_if {|u| u.health <= 0}

    break if combat_over || (elf_attack > 3 && elf_lost)

    total_rounds += 1
  end

  {total_rounds: total_rounds, units: units, elf_lost: elf_lost}
end

def get_combat_outcome(map)
  results = run_combat(map)
  results[:total_rounds] * results[:units].map {|x| x.health}.sum
end

def lowest_elf_victory_attack(map)
  results = nil
  for elf_attack in 4...200
    map_copy = []
    map.each {|r| map_copy << r.clone}
    results = run_combat(map_copy, elf_attack)
    break if !results[:elf_lost]
  end

  results[:total_rounds] * results[:units].map {|x| x.health}.sum
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  map = [
    '#######',
    '#.G...#',
    '#...EG#',
    '#.#.#G#',
    '#..G#E#',
    '#.....#',
    '#######'
  ]
  puts(get_combat_outcome(map))

  map = [
    '#######',
    '#G..#E#',
    '#E#E.E#',
    '#G.##.#',
    '#...#E#',
    '#...E.#',
    '#######'
  ]
  puts(get_combat_outcome(map))

  map = [
    '#######',
    '#E..EG#',
    '#.#G.E#',
    '#E.##E#',
    '#G..#.#',
    '#..E#.#',
    '#######'
  ]
  puts(get_combat_outcome(map))

  map = [
    '#######',
    '#E.G#.#',
    '#.#G..#',
    '#G.#.G#',
    '#G..#.#',
    '#...E.#',
    '#######'
  ]
  puts(get_combat_outcome(map))

  map = [
    '#######',
    '#.E...#',
    '#.#..G#',
    '#.###.#',
    '#E#G#G#',
    '#...#G#',
    '#######'
  ]
  puts(get_combat_outcome(map))

  map = [
    '#########',
    '#G......#',
    '#.E.#...#',
    '#..##..G#',
    '#...##..#',
    '#...#...#',
    '#.G...G.#',
    '#.....G.#',
    '#########'
  ]
  puts(get_combat_outcome(map))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  map = [
    '################################',
    '##########################.#####',
    '##########################.#####',
    '##########################.#.###',
    '#######################......###',
    '#################....#........##',
    '##############.##....G......G.##',
    '#############..#G...##.........#',
    '#############.GG..G..##.......##',
    '#############.................##',
    '#############G.........G....#.##',
    '###########G..........E........#',
    '###########...#####............#',
    '###########..#######...........#',
    '#######.....#########........###',
    '#######....G#########.......####',
    '##...G.G....#########...#....###',
    '#...G..G...G#########.###E...###',
    '##.......#..#########.#####..E##',
    '#............#######..##########',
    '#.GG........G.#####...##########',
    '#................E.....#########',
    '########..........##.###########',
    '#########.....###.....##########',
    '##########.E..##......##########',
    '#######..#....###.E...##########',
    '######.........###.E############',
    '######.#..G....##..#############',
    '######.....##..##.E#############',
    '#######....##.E...E#############',
    '######....G#......##############',
    '################################'
  ]
  puts(get_combat_outcome(map))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  map = [
    '#######',
    '#.G...#',
    '#...EG#',
    '#.#.#G#',
    '#..G#E#',
    '#.....#',
    '#######'
  ]
  puts(lowest_elf_victory_attack(map))

  map = [
    '#######',
    '#E..EG#',
    '#.#G.E#',
    '#E.##E#',
    '#G..#.#',
    '#..E#.#',
    '#######'
  ]
  puts(lowest_elf_victory_attack(map))

  map = [
    '#######',
    '#E.G#.#',
    '#.#G..#',
    '#G.#.G#',
    '#G..#.#',
    '#...E.#',
    '#######'
  ]
  puts(lowest_elf_victory_attack(map))

  map = [
    '#######',
    '#.E...#',
    '#.#..G#',
    '#.###.#',
    '#E#G#G#',
    '#...#G#',
    '#######'
  ]
  puts(lowest_elf_victory_attack(map))

  map = [
    '#########',
    '#G......#',
    '#.E.#...#',
    '#..##..G#',
    '#...##..#',
    '#...#...#',
    '#.G...G.#',
    '#.....G.#',
    '#########'
  ]
  puts(lowest_elf_victory_attack(map))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  map = [
    '################################',
    '##########################.#####',
    '##########################.#####',
    '##########################.#.###',
    '#######################......###',
    '#################....#........##',
    '##############.##....G......G.##',
    '#############..#G...##.........#',
    '#############.GG..G..##.......##',
    '#############.................##',
    '#############G.........G....#.##',
    '###########G..........E........#',
    '###########...#####............#',
    '###########..#######...........#',
    '#######.....#########........###',
    '#######....G#########.......####',
    '##...G.G....#########...#....###',
    '#...G..G...G#########.###E...###',
    '##.......#..#########.#####..E##',
    '#............#######..##########',
    '#.GG........G.#####...##########',
    '#................E.....#########',
    '########..........##.###########',
    '#########.....###.....##########',
    '##########.E..##......##########',
    '#######..#....###.E...##########',
    '######.........###.E############',
    '######.#..G....##..#############',
    '######.....##..##.E#############',
    '#######....##.E...E#############',
    '######....G#......##############',
    '################################'
  ]
  puts(lowest_elf_victory_attack(map))
end


part_1_examples()
part_1_final()
part_2_examples()
part_2_final()
