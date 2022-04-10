#!/usr/bin/env ruby

def get_instructions_from_strings(strings)
  instructions = []

  strings.each do |string|
    values = string.scan(/[0-9]+/).map(&:to_i)
    instruction = {}

    if !string.match(/swap position/).nil?
      instruction = {op: :swap_position, value_1: values[0], value_2: values[1]}
    elsif !string.match(/swap letter/).nil?
      letters = string.scan(/letter [a-z]/)
      instruction = {op: :swap_letter, value_1: letters[0][-1], value_2: letters[1][-1]}
    elsif !string.match(/rotate (left|right)/).nil?
      instruction = {op: :rotate_direction, value_1: string.match(/(left|right)/).to_s, value_2: values[0]}
    elsif !string.match(/rotate based/).nil?
      instruction = {op: :rotate_around, value_1: string.match(/letter [a-z]/).to_s[-1], value_2: nil}
    elsif !string.match(/reverse/).nil?
      instruction = {op: :reverse, value_1: values[0], value_2: values[1]}
    elsif !string.match(/move/).nil?
      instruction = {op: :move, value_1: values[0], value_2: values[1]}
    end

    instructions << instruction
  end

  instructions
end

def get_instructions_from_file(filename)
  get_instructions_from_strings(File.read(filename).split("\n"))
end

def rotate(string, dir, val)
  val = val % string.length

  return string if val == 0

  if dir == 'right'
    return string[(string.length - val)...string.length] + string[0...(string.length - val)]
  end

  return string[val...string.length] + string[0...val]
end

def scramble(string, instructions)
  instructions.each do |instruction|
    case instruction[:op]
      when :swap_position
        tmp = string[instruction[:value_1]]
        string[instruction[:value_1]] = string[instruction[:value_2]]
        string[instruction[:value_2]] = tmp
      when :swap_letter
        v1i = string.index(instruction[:value_1])
        v2i = string.index(instruction[:value_2])
        tmp = string[v1i]

        string[v1i] = string[v2i]
        string[v2i] = tmp
      when :rotate_direction
        string = rotate(string, instruction[:value_1], instruction[:value_2])
      when :rotate_around
        i = string.index(instruction[:value_1])
        num_steps = 1 + i + (i >= 4 ? 1 : 0)
        string = rotate(string, 'right', num_steps)
      when :reverse
        string = string[0...instruction[:value_1]] + string[instruction[:value_1]...(instruction[:value_2] + 1)].reverse + string[(instruction[:value_2] + 1)...string.length]
      when :move
        letter_1 = string[instruction[:value_1]]
        string.delete!(letter_1)
        string = string[0...instruction[:value_2]] + letter_1 + string[instruction[:value_2]...string.length]
      end
  end

  string
end

def unscramble(string, instructions)
  instructions.reverse!

  instructions.each do |instruction|
    case instruction[:op]
      when :swap_position
        tmp = string[instruction[:value_1]]
        string[instruction[:value_1]] = string[instruction[:value_2]]
        string[instruction[:value_2]] = tmp
      when :swap_letter
        v1i = string.index(instruction[:value_1])
        v2i = string.index(instruction[:value_2])
        tmp = string[v1i]

        string[v1i] = string[v2i]
        string[v2i] = tmp
      when :rotate_direction
        string = rotate(string, (instruction[:value_1] == 'right' ? 'left' : 'right'), instruction[:value_2])
      when :rotate_around
        i = string.index(instruction[:value_1])
        # There's definitely a nicer way to figure this out but I'm too tired/lazy.
        num_steps = i.odd? ? (i / 2) + 1 : (string.length - (3 - (i / 2)))
        num_steps = 1 if i == 0

        string = rotate(string, 'left', num_steps)
      when :reverse
        string = string[0...instruction[:value_1]] + string[instruction[:value_1]...(instruction[:value_2] + 1)].reverse + string[(instruction[:value_2] + 1)...string.length]
      when :move
        letter_1 = string[instruction[:value_2]]
        string.delete!(letter_1)
        string = string[0...instruction[:value_1]] + letter_1 + string[instruction[:value_1]...string.length]
      end
  end

  string
end

def part_1_examples
  puts('PART 1 EXAMPLE SOLUTIONS:')
  instructions = get_instructions_from_strings([
    'swap position 4 with position 0',
    'swap letter d with letter b',
    'reverse positions 0 through 4',
    'rotate left 1 step',
    'move position 1 to position 4',
    'move position 3 to position 0',
    'rotate based on position of letter b',
    'rotate based on position of letter d'
  ])
  puts(scramble('abcde', instructions))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  instructions = get_instructions_from_file('day21_input.txt')
  puts(scramble('abcdefgh', instructions))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  instructions = get_instructions_from_strings([
    'swap position 4 with position 0',
    'swap letter d with letter b',
    'reverse positions 0 through 4',
    'rotate left 1 step',
    'move position 1 to position 4',
    'move position 3 to position 0',
    'rotate based on position of letter b',
    'rotate based on position of letter d'
  ])
  puts(unscramble('decab', instructions))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  instructions = get_instructions_from_file('day21_input.txt')
  puts(unscramble('fbgdceah', instructions))
end

part_1_examples()
part_1_final()
part_2_example()
part_2_final()