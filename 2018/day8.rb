#!/usr/bin/env ruby

class Node
  attr_accessor :children
  attr_accessor :metadata

  def initialize()
    @children = []
    @metadata = []
  end
end

def get_numbers_from_file(filename)
  File.open(filename, "r") do |file|
    file.each_line do |line|
      return line.split(' ').map(&:to_i)
    end
  end
end

def construct_tree(numbers)
  return nil if numbers.empty? || numbers.length == 1

  num_children = numbers.shift()
  num_metadata = numbers.shift()

  node = Node.new()

  for i in 0...num_children
    node.children << construct_tree(numbers)
  end

  node.children.compact!

  for i in 0...num_metadata
    node.metadata << numbers.shift()
  end

  node
end

def get_metadata_sum(tree)
  return 0 if tree.nil?

  child_metadata_sum = 0

  tree.children.each do |child|
    child_metadata_sum += get_metadata_sum(child)
  end

  child_metadata_sum + tree.metadata.reduce(0, :+)
end

def get_tree_value(tree)
  return 0 if tree.nil?

  return tree.metadata.reduce(0, :+) if tree.children.length == 0

  total_children_value = 0

  tree.metadata.each do |metadatum|
    next if metadatum <= 0 || metadatum > tree.children.length
    puts "getting child value"
    total_children_value += get_tree_value(tree.children[metadatum - 1])
  end

  total_children_value
end

def part_1
  puts("EXAMPLE SOLUTION:")
  puts(get_metadata_sum(construct_tree([2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2])))
  puts("INPUT SOLUTION:")
  file_input = get_numbers_from_file("day8_input.txt")
  puts(get_metadata_sum(construct_tree(file_input)))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  puts(get_tree_value(construct_tree([2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2])))
  puts("INPUT SOLUTION:")
  file_input = get_numbers_from_file("day8_input.txt")
  puts(get_tree_value(construct_tree(file_input)))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
