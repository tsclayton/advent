#!/usr/bin/env ruby

def get_map_exp_from_file(filename)
  File.read(filename).chomp
end

def get_closing_paren_index(map_exp, i)
  scope = 0

  while i < map_exp.length
    c = map_exp[i]
    if c == ')'
      scope -= 1
      return i if scope <= 0
    elsif c =='('
      scope += 1
    end

    i += 1
  end

  i
end

def update_map(positions, map, direction)
  delta = [0, 0]

  case direction
  when 'N'
    delta[1] += 1
  when 'E'
    delta[0] += 1
  when 'S'
    delta[1] -= 1
  when 'W'
    delta[0] -= 1
  end

  for i in 0...positions.length
    pos = positions[i]
    new_pos = [pos[0] + delta[0], pos[1] + delta[1]]
    map[pos] ||= []
    map[pos] << new_pos if !map[pos].member?(new_pos)

    map[new_pos] ||= []
    map[new_pos] << pos if !map[new_pos].member?(pos)
    positions[i] = new_pos
  end
end

def generate_map(map_exp, positions = [[0, 0]], map = {}, i = 0)
  while i < map_exp.length
    char = map_exp[i]

    if char == ')' || char == '$' || char == '|'
      break
    elsif char == '('
      closing_index = get_closing_paren_index(map_exp, i)
      sub_expr_positions = []
      while i < closing_index
        results = generate_map(map_exp, positions.map(&:clone), map, i + 1)
        i = results[:i]
        sub_expr_positions = (sub_expr_positions + results[:positions]).uniq
      end
      positions = sub_expr_positions
      i = closing_index
    elsif char != '^'
      update_map(positions, map, char)
    end

    i += 1
  end

  {map: map, positions: positions, i: i}
end

def scan_facility(map)
  queue = [[0, 0]]
  paths = {[0, 0] => 0}

  longest_path = 0
  thousand_door_rooms = 0

  while !queue.empty?
    pos = queue.shift

    map[pos].each do |next_room|
      next if !paths[next_room].nil?
      next_cost = paths[pos] + 1
      paths[next_room] = next_cost
      queue << next_room

      thousand_door_rooms += 1 if next_cost >= 1000
      longest_path = next_cost if next_cost > longest_path
    end
  end

  {longest_path: longest_path, thousand_door_rooms: thousand_door_rooms}
end

def get_longest_path_to_room(map_exp)
  map = generate_map(map_exp)[:map]
  scan_facility(map)[:longest_path]
end

def get_thousand_door_room_count(map_exp)
  map = generate_map(map_exp)[:map]
  scan_facility(map)[:thousand_door_rooms]
end

def part_1_examples()
  puts("PART 1 EXAMPLE SOLUTIONS:")
  puts(get_longest_path_to_room('^WNE$'))
  puts(get_longest_path_to_room('^ENWWW(NEEE|SSE(EE|N))$'))
  puts(get_longest_path_to_room('^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$'))
  puts(get_longest_path_to_room('^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$'))
  puts(get_longest_path_to_room('^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$'))
end

def part_1_final()
  puts("PART 1 FINAL SOLUTION:")
  puts(get_longest_path_to_room(get_map_exp_from_file('day20_input.txt')))
end

def part_2_final()
  puts("PART 2 FINAL SOLUTION:")
  puts(get_thousand_door_room_count(get_map_exp_from_file('day20_input.txt')))
end

part_1_examples()
part_1_final()
part_2_final()