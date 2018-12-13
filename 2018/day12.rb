#!/usr/bin/env ruby

def get_input_from_file(filename)
  rules = {}
  initial_state = ''

  File.open(filename, "r") do |file|
    file.each_line do |line|
      if !line.match('initial').nil?
        initial_state_string = line.match(/[.#]+/).to_s
        initial_state = {}
        for i in 0...initial_state_string.length
          initial_state[i] = initial_state_string[i]
        end
      else
        split_rules = line.gsub(/\s+/, '').split('=>')
        rules[split_rules[0]] = split_rules[1]
      end
    end
  end

  {initial_state: initial_state, rules: rules}
end

def plants_after_nun_generations(state, rules, num_generations)
  # negative indexes mean I use hashes as pseudo arrays
  state[-1] = '.'
  state[-2] = '.'
  state[state.keys.max + 1] = '.'
  state[state.keys.max + 2] = '.'

  for i in 0...num_generations
    new_generation = {}

    state.keys.each do |key|
      configuration = ''
      for pot in (key - 2)..(key + 2)
        new_generation[pot] ||= '.'
        state[pot] ||= '.'
        configuration << state[pot]
      end

      rules[configuration] ||= '.'
      new_generation[key] = rules[configuration]
    end

    state = new_generation
  end

  state
end

def potted_plant_sum(state, rules, num_generations)
  new_state = plants_after_nun_generations(state, rules, num_generations)

  sum = 0
  plants = []

  keys = new_state.keys.sort
  keys.each do |key|
    val = new_state[key]
    if val == '#'
      plants << key
      sum += key
    end
  end

  sum
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = get_input_from_file("day12_example.txt")
  puts(potted_plant_sum(example_input[:initial_state], example_input[:rules], 20))

  puts("INPUT SOLUTION:")
  file_input = get_input_from_file("day12_input.txt")
  puts(potted_plant_sum(file_input[:initial_state], file_input[:rules], 20))
end

# Fuck this puzzle
def part_2
  puts("INPUT SOLUTION:")
  file_input = get_input_from_file("day12_input.txt")

  previous_sum = 0
  previous_difference = 0

  current_sum = 0
  current_difference = 0
  current_generation = 0

  for i in 100...1000
    current_sum = potted_plant_sum(file_input[:initial_state], file_input[:rules], i)
    current_generation = i
    current_difference = current_sum - previous_sum

    # find the point where it starts increasing linearly
    break if current_difference == previous_difference

    previous_sum = current_sum
    previous_difference = current_difference
  end

  puts(current_sum + (current_difference * (50000000000 - current_generation)))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
