#!/usr/bin/env ruby

def get_erosion(pos, depth, target, cache)
  (get_geologic_index(pos, depth, target, cache) + depth) % 20183
end

def get_geologic_index(pos, depth, target, cache)
  return cache[pos] if !cache[pos].nil?

  geologic_index = 0
  if pos == [0, 0] || pos == target
    geologic_index = 0
  elsif pos[1] == 0
    geologic_index = pos[0] * 16807
  elsif pos[0] == 0
    geologic_index = pos[1] * 48271
  else
    geologic_index = get_erosion([pos[0] - 1, pos[1]], depth, target, cache) * get_erosion([pos[0], pos[1] - 1], depth, target, cache)
  end

  cache[pos] = geologic_index
  geologic_index
end

def get_type(pos, depth, target, cache)
  ['.', '=', '|'][get_erosion(pos, depth, target, cache) % 3]
end

def get_total_risk_level(depth, target)
  total_risk_level = 0
  cache = {}

  for y in 0..target[1]
    for x in 0..target[0]
      total_risk_level += (get_erosion([x, y], depth, target, cache) % 3)
    end
  end

  total_risk_level
end

def generate_map(depth, target)
  map = []
  cache = {}

  for y in 0..target[1]
    row = ''
    for x in 0..target[0]
      type = get_type([x, y], depth, target, cache)
      if [x, y] == [0, 0]
        row += 'M'
      elsif [x, y] == target
        row += 'T'
      else
        row += type
      end
    end
    map << row
  end

  map
end

def get_next_positions(pos, target)
  positions = []

  [[0, 1], [1, 0], [-1, 0], [0, -1]].each do |direction|
    adjacent_space = [pos[0] + direction[0], pos[1] + direction[1]]
    positions << adjacent_space if adjacent_space[0] >= 0 && adjacent_space[1] >= 0
  end

  positions.sort_by {|pos| (pos[0] - target[0]).abs + (pos[1] - target[1]).abs}
end

def type_supports_tools(type, tools)
  case type
  when '.'
    return (tools[:torch] && !tools[:gear]) || (!tools[:torch] && tools[:gear])
  when '='
    return (!tools[:torch] && tools[:gear]) || (!tools[:torch] && !tools[:gear])
  when '|'
    return (tools[:torch] && !tools[:gear]) || (!tools[:torch] && !tools[:gear])
  end

  false
end

def get_quickest_path(depth, target)
  map_cache = {}
  path_cache = {}

  queue_queue = [[{pos: [0, 0], tools: {torch: true, gear: false}}]]
  total_steps = 0

  while !queue_queue.empty?
    queue = queue_queue.shift
    queue ||= []

    while !queue.empty?
      state = queue.shift

      next if !path_cache[state].nil?
      path_cache[state] = total_steps

      if state[:pos] == target
        return total_steps if state[:tools][:torch]
          
        queue_queue[6] ||= []
        queue_queue[6].unshift({pos: state[:pos], tools: {torch: true, gear: false}})
        next
      end

      current_type = get_type(state[:pos], depth, target, map_cache)

      get_next_positions(state[:pos], target).each do |next_pos|
        step_cost = 1

        next_tools = state[:tools]
        next_type = get_type(next_pos, depth, target, map_cache)
        if current_type != next_type && !type_supports_tools(next_type, state[:tools])
          case next_type
          when '.'
            next_tools = (current_type == '=' ? {torch: false, gear: true} : {torch: true, gear: false})
          when '='
            next_tools = (current_type == '.' ? {torch: false, gear: true} : {torch: false, gear: false})
          when '|'
            next_tools = (current_type == '.' ? {torch: true, gear: false} : {torch: false, gear: false})
          end
          step_cost += 7
        end

        queue_queue[step_cost - 1] ||= []
        queue_queue[step_cost - 1] << {pos: next_pos, tools: next_tools}
      end
    end

    total_steps += 1
  end

  -1
end

def part_1_example()
  puts("PART 1 EXAMPLE SOLUTION:")
  puts(generate_map(510, [10, 10]))
  puts(get_total_risk_level(510, [10, 10]))
end

def part_1_final()
  puts("PART 1 FINAL SOLUTION:")
  puts(get_total_risk_level(11739, [11, 718]))
end

def part_2_example()
  puts("PART 2 EXAMPLE SOLUTION:")
  puts(get_quickest_path(510, [10, 10]))
end

def part_2_final()
  puts("PART 2 FINAL SOLUTION:")
  puts(get_quickest_path(11739, [11, 718]))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()
