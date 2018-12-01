#!/usr/bin/env ruby

def parse_file(filename)
  File.open(filename, "r") do |file|
    file.each_line do |line|
      return line.split(',').map(&:to_i)
    end
  end
end

def parse_file_as_ascii(filename)
  File.open(filename, "r") do |file|
    file.each_line do |line|
      line.gsub!(/\s+/,'')
      return line.each_char.map(&:ord)
    end
  end
end

def generate_sparse_hash(numbers, lengths, iterations)
  skip_size = 0
  curr_index = 0

  (1..iterations).each do |iteration|
    lengths.each do |length|
      start_index = curr_index
      end_index = curr_index + length - 1

      while start_index < end_index
        # swap numbers
        temp = numbers[start_index % numbers.length]
        numbers[start_index % numbers.length] = numbers[end_index % numbers.length]
        numbers[end_index % numbers.length] = temp

        start_index += 1
        end_index -= 1
      end

      curr_index = (curr_index + length + skip_size) % numbers.length

      skip_size += 1
    end
  end

  numbers
end

def generate_dense_hash(sparse_hash)
  sparse_hash.each_slice(16).map {|partition| partition.reduce(&:^)}
end

def convert_to_hex_string(dense_hash)
  dense_hash.map do |part|
    hex_part = part.to_s(16)
    # append leading 0 if necessary
    hex_part.length == 1 ? '0' + hex_part : hex_part
  end.join('')
end

def multiply_first_two(numbers, lengths)
  generate_sparse_hash(numbers, lengths, 1)
  numbers[0] * numbers[1]
end

def knot_hash(lengths)
  numbers = (0..255).to_a
  generate_sparse_hash(numbers, lengths + [17, 31, 73, 47, 23], 64)
  dense_hash = generate_dense_hash(numbers)
  convert_to_hex_string(dense_hash)
end

def part_1
  puts("EXAMPLE SOLUTION:")
  puts(multiply_first_two((0..4).to_a, [3, 4, 1, 5]))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day10_input.txt")
  puts(multiply_first_two((0..255).to_a, file_input))
end

def part_2
  puts("EXAMPLE SOLUTIONS:")
  puts(knot_hash(''.each_char.map(&:ord)))
  puts(knot_hash('AoC 2017'.each_char.map(&:ord)))
  puts(knot_hash('1,2,3'.each_char.map(&:ord)))
  puts(knot_hash('1,2,4'.each_char.map(&:ord)))
  puts("INPUT SOLUTION:")
  file_input = parse_file_as_ascii("day10_input.txt")
  puts(knot_hash(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
