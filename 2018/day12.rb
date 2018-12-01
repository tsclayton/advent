#!/usr/bin/env ruby

def parse_file(filename)
  neighbours = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      # store neighbours list only because program ids are in order (thus index of neighbours array)
      neighbours << line.gsub(/\s+/, '').split('<->')[1].split(',').map(&:to_i)
    end
  end

  neighbours
end

def get_program_group(input, pid, program_group)
  # Could optimize by using a hash for constant-time lookup, but I'm being quick and dirty here
  return [] if program_group.include?(pid)

  program_group += [pid]

  input[pid].each do |neighbour_id|
    program_group += get_program_group(input, neighbour_id, program_group)
  end

  program_group.uniq
end

def program_group_length(input, pid)
  get_program_group(input, pid, []).length
end

def get_total_number_of_groups(input)
  grouped_programs = []
  num_groups = 0

  for i in 0...input.length do
    next if grouped_programs.include?(i)

    grouped_programs += get_program_group(input, i, [])

    num_groups += 1
  end

  num_groups
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = parse_file("day12_example.txt")
  puts(program_group_length(example_input, 0))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day12_input.txt")
  puts(program_group_length(file_input, 0))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  example_input = parse_file("day12_example.txt")
  puts(get_total_number_of_groups(example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day12_input.txt")
  puts(get_total_number_of_groups(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
