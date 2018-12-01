#!/usr/bin/env ruby

def parse_file(filename)
  nodes = {}

  File.open(filename, "r") do |file|
    file.each_line do |line|
      line.gsub!(/\s+/, ' ')
      line.gsub!(/[\(\)\-\>,]/, '')
      parsed_line = line.split(' ')

      name = parsed_line.shift
      weight = parsed_line.shift.to_i
      children = parsed_line
      nodes[name] = {name: name, weight: weight, children: children}
    end
  end

  return nodes
end

def get_bottom_node(nodes)
  child_nodes = nodes.values.inject([]) {|children, node| children + node[:children] }.uniq
  return [nodes.keys - child_nodes][0][0]
end

def calculate_weight(node_name, node_map)
  node = node_map[node_name]
  return node[:weight] + node[:children].inject(0) {|sum, child_name| sum + calculate_weight(child_name, node_map)}
end

def get_proper_weight(node_name, node_map)
  node = node_map[node_name]
  weights = node[:children].map {|child_name| calculate_weight(child_name, node_map)}
  puts "weights: #{weights}"

  # weights are the same, sub-tree is balanced
  return -1 if weights.uniq.length == 1

  differing_weight = 0
  matching_weight = weights[0]
  mismatched_node = ''

  for i in 0...weights.length
    if weights[i] != matching_weight
      if i > 2 || weights[1] != weights[2]
        mismatched_node = node[:children][i]
        differing_weight = weights[i]
        break
      else # first is the odd one out
        matching_weight = weights[1]
        mismatched_node = node[:children][0]
        differing_weight = weights[0]
        break
      end
    end
  end

  correct_sub_tree_weight = get_proper_weight(mismatched_node, node_map)
  if (correct_sub_tree_weight == -1)
    difference = matching_weight - differing_weight
    puts "difference: #{difference}"
    puts "matching_weight: #{matching_weight}"
    puts "differing_weight: #{differing_weight}"
    puts "node_weight: #{node_map[mismatched_node][:weight]}"
    return node_map[mismatched_node][:weight] + difference
    # child tree is balanced, problem must be here
  end

  # upper tree imbalanced, so we must be passing down the proper sub tree weight
  return correct_sub_tree_weight
end

def part_1
  puts("EXAMPLE SOLUTIONS:")
  example_input = parse_file("day7_example.txt")
  puts(get_bottom_node(example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day7_input.txt")
  puts(get_bottom_node(file_input))
end


def part_2
  puts("EXAMPLE SOLUTIONS:")
  example_input = parse_file("day7_example.txt")
  puts(get_proper_weight(get_bottom_node(example_input), example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day7_input.txt")
  puts(get_proper_weight(get_bottom_node(file_input), file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
