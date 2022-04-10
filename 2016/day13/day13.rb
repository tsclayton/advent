#!/usr/bin/env ruby

def is_open_space(map, pos, favn)
  return map[pos] if !map[pos].nil?

  val = (pos[0] * pos[0]) + (3 * pos[0]) + (2 * pos[0] * pos[1]) + pos[1] + (pos[1] * pos[1]) + favn
  is_open = val.to_s(2).count('1').even?
  map[pos] = is_open

  is_open
end

def shortest_path(favn, dest)
  map = {}

  start_pos = [1, 1]
  distances = {start_pos => 0}
  pos_queue = [start_pos]

  while !pos_queue.empty?
    pos = pos_queue.shift
    distance = distances[pos]

    return distance if pos == dest

    next_posns = []

    [[1, 0], [0, 1], [-1, 0], [0, -1]].each do |dir|
      next_pos = [pos[0] + dir[0], pos[1] + dir[1]]
      next_posns << next_pos if next_pos[0] >= 0 && next_pos[1] >= 0
    end

    next_posns.each do |next_pos|
      if is_open_space(map, next_pos, favn) && distances[next_pos].nil?
        pos_queue << next_pos
        distances[next_pos] = distance + 1
      end
    end
  end

  0
end

def num_reachable_spaces(favn, max_steps)
  map = {}

  start_pos = [1, 1]
  distances = {start_pos => 0}
  pos_queue = [start_pos]

  while !pos_queue.empty?
    pos = pos_queue.shift
    distance = distances[pos]

    next if distance >= max_steps

    next_posns = []

    [[1, 0], [0, 1], [-1, 0], [0, -1]].each do |dir|
      next_pos = [pos[0] + dir[0], pos[1] + dir[1]]
      next_posns << next_pos if next_pos[0] >= 0 && next_pos[1] >= 0
    end

    next_posns.each do |next_pos|
      if is_open_space(map, next_pos, favn) && distances[next_pos].nil?
        pos_queue << next_pos
        distances[next_pos] = distance + 1
      end
    end
  end

  distances.length
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  puts(shortest_path(10, [7, 4]))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  puts(shortest_path(1362, [31, 39]))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  puts(num_reachable_spaces(1362, 50))
end

part_1_example()
part_1_final()
part_2_final()