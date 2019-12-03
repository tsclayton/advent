#!/usr/bin/env ruby

def day2_input 
  [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,9,19,1,13,19,23,2,23,9,27,1,6,27,31,2,10,31,35,1,6,35,39,2,9,39,43,1,5,43,47,2,47,13,51,2,51,10,55,1,55,5,59,1,59,9,63,1,63,9,67,2,6,67,71,1,5,71,75,1,75,6,79,1,6,79,83,1,83,9,87,2,87,10,91,2,91,10,95,1,95,5,99,1,99,13,103,2,103,9,107,1,6,107,111,1,111,5,115,1,115,2,119,1,5,119,0,99,2,0,14,0]
end

def run_program(ints)
  i = 0

  while i < ints.length - 3
    opcode = ints[i]
    input1 = ints[ints[i + 1]]
    input2 = ints[ints[i + 2]]
    result = 0

    if (input1.nil? || input2.nil?)
      puts ("OUT OF RANGE!")
      return ints
    end

    case opcode
    when 1
      result = input1 + input2
    when 2
      result = input1 * input2
    when 99
      return ints
    else
      puts("SOMETHING WENT WRONG!")
      return ints
    end

    ints[ints[i + 3]] = result

    i += 4
  end

  ints
end

def run_with_noun_and_verb(ints, noun, verb)
  input = ints
  input[1] = noun
  input[2] = verb
  run_program(input)
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  puts(run_program([1,0,0,0,99])[0])
  puts(run_program([2,3,0,3,99])[0])
  puts(run_program([2,4,4,5,99,0])[0])
  puts(run_program([1,1,1,4,99,5,6,0,99])[0])
  puts(run_program([1,9,10,3,2,3,11,0,99,30,40,50])[0])
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  puts(run_with_noun_and_verb(day2_input(), 12, 2)[0])
end

def part_2_final
  # After playing with the program, it appears that increasing the noun by 1 increases the output by 207360 and increasing the verb by one increases the output by 1
  # noun: 93, verb: 42
  puts((100 * 93) + 42)
end

part_1_examples()
part_1_final()
# part_2_examples()
part_2_final()
