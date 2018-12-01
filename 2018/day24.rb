#!/usr/bin/env ruby

class Component
  attr_accessor :left_port
  attr_accessor :right_port

  def initialize(left_port, right_port)
    @left_port = left_port
    @right_port = right_port
  end

  def strength()
    @left_port + @right_port
  end
end

def parse_file(filename)
  components = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      sides = line.gsub(/\s+/, '').split('/').map(&:to_i)
      components << Component.new(sides[0], sides[1])
    end
  end

  components
end

def strongest_bridge_stength(components, current_bridge = [])
  port_number = current_bridge.empty? ? 0 : current_bridge[-1].right_port

  next_components = components.select {|c| c.left_port == port_number}
  swapped_components = components.select {|c| c.right_port == port_number} - next_components

  max_strength = 0
  (next_components + swapped_components).each_with_index do |component, i|
    # swap ports around if necessary
    component_to_use = (i >= next_components.length ? Component.new(component.right_port, component.left_port) : component)
    strength = strongest_bridge_stength(components - [component], current_bridge + [component_to_use])
    max_strength = strength if strength > max_strength
  end

  return max_strength + (current_bridge.empty? ? 0 : current_bridge[-1].strength())
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = parse_file("day24_example.txt")
  puts(strongest_bridge_stength(example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day24_input.txt")
  puts(strongest_bridge_stength(file_input))
end

def bridge_strength(bridge)
  bridge.map(&:strength).reduce(:+) || 0
end

def strongest_longest_bridge(components, current_bridge = [])
  port_number = current_bridge.empty? ? 0 : current_bridge[-1].right_port

  next_components = components.select {|c| c.left_port == port_number}
  swapped_components = components.select {|c| c.right_port == port_number} - next_components

  best_bridge = current_bridge

  (next_components + swapped_components).each_with_index do |component, i|
    # swap ports around if necessary
    component_to_use = (i >= next_components.length ? Component.new(component.right_port, component.left_port) : component)
    bridge = strongest_longest_bridge(components - [component], current_bridge + [component_to_use])

    if bridge.length > best_bridge.length || (bridge.length == best_bridge.length && bridge_strength(bridge) > bridge_strength(best_bridge))
      best_bridge = bridge
    end
  end

  return best_bridge
end

def strongest_longest_bridge_strength(components)
  bridge_strength(strongest_longest_bridge(components))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  example_input = parse_file("day24_example.txt")
  puts(strongest_longest_bridge_strength(example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day24_input.txt")
  puts(strongest_longest_bridge_strength(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
