#!/usr/bin/env ruby

def get_next_row(previous_row)
  next_row = ''

  for x in 0...previous_row.length
    trap_str = ''

    for i in 0...3
      j = x + (i - 1)
      if j < 0 || j >= previous_row.length
        trap_str << '.'
      else
        trap_str << previous_row[j]
      end
    end

    is_trap = ['^^.', '.^^', '^..', '..^'].member?(trap_str)
    next_row << (is_trap ? '^' : '.')
  end

  next_row
end

def gen_map(num_rows, starting_row)
  map = [starting_row]

  for i in 0...(num_rows - 1)
    map << get_next_row(map[-1])
  end

  map
end

def num_safe_tiles(num_rows, starting_row)
  map = gen_map(num_rows, starting_row)
  map.map {|row| row.count('.') }.sum
end

def part_1_examples
  puts('PART 1 EXAMPLE SOLUTIONS:')
  puts(gen_map(3, '..^^.'))
  puts ""
  puts(gen_map(10, '.^^.^.^^^^'))
  puts(num_safe_tiles(10, '.^^.^.^^^^'))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  puts(num_safe_tiles(40, '^.^^^..^^...^.^..^^^^^.....^...^^^..^^^^.^^.^^^^^^^^.^^.^^^^...^^...^^^^.^.^..^^..^..^.^^.^.^.......'))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  puts(gen_map(3, '..^^.'))
  puts(gen_map(10, '.^^.^.^^^^'))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  puts(num_safe_tiles(400_000, '^.^^^..^^...^.^..^^^^^.....^...^^^..^^^^.^^.^^^^^^^^.^^.^^^^...^^...^^^^.^.^..^^..^..^.^^.^.^.......'))
end

part_1_examples()
part_1_final()
part_2_final()
