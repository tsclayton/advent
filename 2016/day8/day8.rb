#!/usr/bin/env ruby

def get_instructions_from_strings(strings)
  strings.map do |str|
    inputs = str.scan(/[0-9]+/).map(&:to_i)
    op = :rect

    if str.match(/row/)
      op = :rotate_row
    elsif str.match(/col/)
      op = :rotate_col
    end

    {op: op, inputs: inputs}
  end
end

def get_instructions_from_file(filename)
  get_instructions_from_strings(File.read(filename).split("\n"))
end

def run_screen_instructions(height, width, instructions)
  screen = []

  for y in 0...height
    screen << ('.' * width)
  end

  instructions.each do |instruction|
    case instruction[:op]
    when :rect
      for x in 0...instruction[:inputs][0]
        for y in 0...instruction[:inputs][1]
          screen[y][x] = '#'
        end
      end
    when :rotate_row
      str_copy = screen[instruction[:inputs][0]].clone

      for x in 0...screen[instruction[:inputs][0]].length
        shifted_x = (x + instruction[:inputs][1]) % screen[instruction[:inputs][0]].length
        screen[instruction[:inputs][0]][shifted_x] = str_copy[x]
      end
    when :rotate_col
      str_copy = ''

      for y in 0...screen.length
        str_copy << screen[y][instruction[:inputs][0]]
      end

      for y in 0...screen.length
        shifted_y = (y + instruction[:inputs][1]) % screen.length
        screen[shifted_y][instruction[:inputs][0]] = str_copy[y]
      end
    end
  end

  screen
end

def lit_pixel_count(height, width, instructions)
  screen = run_screen_instructions(height, width, instructions)
  screen.map {|row| row.count('#')}.sum
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  instructions = get_instructions_from_strings([
    'rect 3x2',
    'rotate column x=1 by 1',
    'rotate row y=0 by 4',
    'rotate column x=1 by 1'
  ])

  puts(run_screen_instructions(3, 7, instructions))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  instructions = get_instructions_from_file('day8_input.txt')
  puts(lit_pixel_count(6, 50, instructions))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  instructions = get_instructions_from_file('day8_input.txt')
  puts(run_screen_instructions(6, 50, instructions))
end

part_1_example()
part_1_final()
part_2_final()