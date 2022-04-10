#!/usr/bin/env ruby

def get_data_from_file(filename)
  File.read(filename).chomp
end

def decompress(data, recursive = false)
  decompressed = ''
  i = 0

  while i < data.length
    char = data[i]

    if char == '('
      i += 1

      group_size_str = ''
      while data[i] != 'x'
        group_size_str << data[i]
        i += 1
      end

      group_size = group_size_str.to_i
      i += 1

      repetitions_str = ''
      while data[i] != ')'
        repetitions_str << data[i]
        i += 1
      end

      repetitions = repetitions_str.to_i
      i+= 1

      group = data[i...(i + group_size)]
      decompressed << ((recursive ? decompress(group, recursive) : group) * repetitions)
      i += group_size
    else
      decompressed << char
      i += 1
    end
  end

  decompressed
end

def part_1_examples
  puts('PART 1 EXAMPLE SOLUTIONS:')

  puts(decompress('ADVENT'))
  puts(decompress('A(1x5)BC'))
  puts(decompress('(3x3)XYZ'))
  puts(decompress('A(2x2)BCD(2x2)EFG'))
  puts(decompress('(6x1)(1x3)A'))
  puts(decompress('X(8x2)(3x3)ABCY'))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  puts(decompress(get_data_from_file('day9_input.txt')).length)
end

def part_2_examples
  puts('PART 2 EXAMPLE SOLUTIONS:')

  puts(decompress('(3x3)XYZ', true))
  puts(decompress('X(8x2)(3x3)ABCY', true))
  puts(decompress('(27x12)(20x12)(13x14)(7x10)(1x12)A', true).length)
  puts(decompress('(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN', true).length)
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  puts(decompress(get_data_from_file('day9_input.txt'), true).length)
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()