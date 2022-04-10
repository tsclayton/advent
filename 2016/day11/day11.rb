#!/usr/bin/env ruby

def get_state_string(state)
  sorted_parts = state[:parts].sort_by {|element, part| [part[:generator_floor], part[:chip_floor]] }
  "#{state[:elevator]}E|" + sorted_parts.map {|sorted_part| "#{sorted_part[1][:generator_floor]}G#{sorted_part[1][:chip_floor]}C"}.join('|')
end

def deep_copy(state)
  copy = {elevator: state[:elevator], parts: {}}

  state[:parts].each do |element, part|
    copy[:parts][element] ||= {}
    copy[:parts][element][:generator_floor] = part[:generator_floor]
    copy[:parts][element][:chip_floor] = part[:chip_floor]
  end

  copy
end

def is_valid_floor(floor_generators, floor_chips)
  unpaired_chips = floor_chips - floor_generators
  unpaired_chips.length == 0 || floor_generators.length == 0
end

def can_move_parts(parts_to_move, current_floor_generators, current_floor_chips, next_floor_generators, next_floor_chips)
  generators = []
  chips = []

  parts_to_move.each do |part|
    generators << part[:element] if part[:is_generator]
    chips << part[:element] if !part[:is_generator]
  end

  is_valid_floor(current_floor_generators - generators, current_floor_chips - chips) && is_valid_floor(next_floor_generators + generators, next_floor_chips + chips)
end

def get_next_states(state, distances)
  next_states = []

  [1, -1].each do |direction|
    next_floor = state[:elevator] + direction
    next if next_floor < 1 || next_floor > 4

    parts_to_move = []
    current_floor_generators = []
    current_floor_chips = []
    next_floor_generators = []
    next_floor_chips = []

    state[:parts].each do |element, part|
      parts_to_move << {element: element, is_generator: true} if part[:generator_floor] == state[:elevator]
      parts_to_move << {element: element, is_generator: false} if part[:chip_floor] == state[:elevator]

      current_floor_generators << element if part[:generator_floor] == state[:elevator]
      current_floor_chips << element if part[:chip_floor] == state[:elevator]
      next_floor_generators << element if part[:generator_floor] == next_floor
      next_floor_chips << element if part[:chip_floor] == next_floor
    end

    for i in 0...parts_to_move.length
      if can_move_parts([parts_to_move[i]], current_floor_generators, current_floor_chips, next_floor_generators, next_floor_chips)
        next_state = deep_copy(state)
        next_state[:elevator] = next_floor
        next_state[:parts][parts_to_move[i][:element]][:generator_floor] = next_floor if parts_to_move[i][:is_generator]
        next_state[:parts][parts_to_move[i][:element]][:chip_floor] = next_floor if !parts_to_move[i][:is_generator]
        next_states << next_state
      end

      for j in (i + 1)...parts_to_move.length
        if can_move_parts([parts_to_move[i], parts_to_move[j]], current_floor_generators, current_floor_chips, next_floor_generators, next_floor_chips)
          next_state = deep_copy(state)
          next_state[:elevator] = next_floor
          next_state[:parts][parts_to_move[i][:element]][:generator_floor] = next_floor if parts_to_move[i][:is_generator]
          next_state[:parts][parts_to_move[i][:element]][:chip_floor] = next_floor if !parts_to_move[i][:is_generator]

          next_state[:parts][parts_to_move[j][:element]][:generator_floor] = next_floor if parts_to_move[j][:is_generator]
          next_state[:parts][parts_to_move[j][:element]][:chip_floor] = next_floor if !parts_to_move[j][:is_generator]
          next_states << next_state
        end
      end
    end
  end

  next_states.filter { |next_state| distances[get_state_string(next_state)].nil? }
end

def min_assembly_steps(start_state)
  distances = {get_state_string(start_state) => 0}
  state_queue = [start_state]

  while !state_queue.empty?
    state = state_queue.shift
    state_str = get_state_string(state)
    distance = distances[state_str]

    is_complete = true

    state[:parts].each do |element, part|
      if part[:generator_floor] != 4 || part[:chip_floor] != 4
        is_complete = false
        break
      end
    end

    return distance if is_complete

    next_states = get_next_states(state, distances)

    next_states.each do |next_state|
      state_queue << next_state
      next_state_str = get_state_string(next_state)
      distances[get_state_string(next_state)] = distance + 1
    end
  end

  0
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  state = {
    elevator: 1,
    parts: {
      hydrogen: {generator_floor: 2, chip_floor: 1},
      lithium: {generator_floor: 3,  chip_floor: 1}
    }
  }

  puts(min_assembly_steps(state))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  state = {
    elevator: 1,
    parts: {
      cobalt: {generator_floor: 2, chip_floor: 3},
      curium: {generator_floor: 2, chip_floor: 3},
      plutonium: {generator_floor: 2, chip_floor: 3},
      promethium: {generator_floor: 1, chip_floor: 1},
      ruthenium: {generator_floor: 2, chip_floor: 3}
    }
  }

  puts(min_assembly_steps(state))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  state = {
    elevator: 1,
    parts: {
      cobalt: {generator_floor: 2, chip_floor: 3},
      curium: {generator_floor: 2, chip_floor: 3},
      dilithium: {generator_floor: 1, chip_floor: 1},
      elerium: {generator_floor: 1, chip_floor: 1},
      plutonium: {generator_floor: 2, chip_floor: 3},
      promethium: {generator_floor: 1, chip_floor: 1},
      ruthenium: {generator_floor: 2, chip_floor: 3}
    }
  }

  puts(min_assembly_steps(state))
end

part_1_example()
part_1_final()
part_2_final()