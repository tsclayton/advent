#!/usr/bin/env ruby

def get_polymer_from_file(filename)
  File.open(filename, "r") do |file|
    file.each_line do |line|
      return line.gsub(/\s/ , '')
    end
  end
end

def reduce_polymer(polymer)
  i = 0

  while i < (polymer.length - 1)
    break if polymer[i].nil? || polymer[i+1].nil?
    if polymer[i] != polymer[i + 1] && polymer[i].downcase == polymer[i + 1].downcase
      polymer.slice!(i)
      polymer.slice!(i)
      i = [i - 2, -1].max
    end

    i += 1
  end

  polymer
end

def reduced_polymer_length(polymer)
  reduced_polymer = reduce_polymer(polymer)
  reduced_polymer.length
end

def shortest_reduced_polymer_length(polymer)
  alphabet = "abcdefghijklmnopqrstuvwxyz"
  min_length = nil

  for i in 0...alphabet.length
    subbed_polymer = polymer.gsub(alphabet[i], '').gsub(alphabet[i].upcase, '')
    reduced_polymer = reduce_polymer(subbed_polymer)
    if min_length == nil || reduced_polymer.length < min_length
      min_length = reduced_polymer.length
    end
  end

  min_length
end

def part_1
  puts("EXAMPLE SOLUTION:")
  puts(reduced_polymer_length("dabAcCaCBAcCcaDA"))
  puts("INPUT SOLUTION:")
  file_input = get_polymer_from_file("day5_input.txt")
  puts(reduced_polymer_length(file_input))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  puts(shortest_reduced_polymer_length("dabAcCaCBAcCcaDA"))
  puts("INPUT SOLUTION:")
  file_input = get_polymer_from_file("day5_input.txt")
  puts(shortest_reduced_polymer_length(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
