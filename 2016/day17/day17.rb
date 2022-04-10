#!/usr/bin/env ruby

require 'digest'

def get_next_states(passcode, state)
  next_states = []

  md5 = Digest::MD5.hexdigest(passcode + state[:path])

  directions = [[0, -1], [0, 1], [-1, 0], [1, 0]]
  dir_letters = 'UDLR'

  for i in 0...4
    if ['b', 'c', 'd', 'e', 'f'].member?(md5[i])
      next_pos = [state[:pos][0] + directions[i][0], state[:pos][1] + directions[i][1]]

      if next_pos[0] >= 0 && next_pos[0] <= 3 && next_pos[1] >= 0 && next_pos[1] <= 3
        next_states << {pos: next_pos, path: state[:path] + dir_letters[i]}
      end
    end
  end

  next_states
end

def shortest_path(passcode)
  state_queue = [{pos: [0, 0], path: ''}]

  while !state_queue.empty?
    state = state_queue.shift

    return state[:path] if state[:pos] == [3, 3]

    next_states = get_next_states(passcode, state)

    next_states.each do |next_state|
      state_queue << next_state
    end
  end

  'NO PATHS FOUND'
end

def longest_path_length(passcode)
  state_queue = [{pos: [0, 0], path: ''}]
  longest_valid_path_length = 0

  while !state_queue.empty?
    state = state_queue.shift

    if state[:pos] == [3, 3]
      longest_valid_path_length = state[:path].length
      next
    end

    next_states = get_next_states(passcode, state)

    next_states.each do |next_state|
      state_queue << next_state
    end
  end

  longest_valid_path_length
end


def part_1_examples
  puts('PART 1 EXAMPLE SOLUTIONS:')
  puts(shortest_path('hijkl'))
  puts(shortest_path('ihgpwlah'))
  puts(shortest_path('kglvqrro'))
  puts(shortest_path('ulqzkmiv'))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  puts(shortest_path('lpvhkcbi'))
end

def part_2_example
  puts('PART 1 EXAMPLE SOLUTIONS:')
  puts(longest_path_length('ihgpwlah'))
  puts(longest_path_length('kglvqrro'))
  puts(longest_path_length('ulqzkmiv'))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  puts(longest_path_length('lpvhkcbi'))
end

part_1_examples()
part_1_final()
part_2_example()
part_2_final()
