#!/usr/bin/env ruby

def get_instructions_from_file(filename)
  instructions = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      instructions << {opcode: line.match(/[a-z]+/).to_s, value: line.match(/[+-][0-9]+/).to_s.to_i}
    end
  end

  instructions
end

def run_instructions(instructions)
  accumulator = 0
  ip = 0
  run_instructions = {}

  while ip < instructions.length
    if !run_instructions[ip].nil?
      return {accumulator: accumulator, terminated: false}
    else
      run_instructions[ip] = true
    end

    case instructions[ip][:opcode]
    when 'acc'
      accumulator += instructions[ip][:value]
    when 'jmp'
      ip += instructions[ip][:value] - 1
    end

    ip += 1
  end

  {accumulator: accumulator, terminated: true}
end

def fix_instructions(instructions)
  for i in 0...instructions.length
    new_instruction = nil

    if instructions[i][:opcode] == 'jmp'
      new_instruction = {opcode: 'nop', value: instructions[i][:value]}
    elsif instructions[i][:opcode] == 'nop'
      new_instruction = {opcode: 'jmp', value: instructions[i][:value]}
    end

    if !new_instruction.nil?
      result = run_instructions(instructions[0...i] + [new_instruction] + instructions[(i + 1)...instructions.length])
      puts "fixed instruction = #{i}" if result[:terminated]
      return result[:accumulator] if result[:terminated]
    end
  end

  -1
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  instructions = [
    {opcode: 'nop', value: 0},
    {opcode: 'acc', value: 1},
    {opcode: 'jmp', value: 4},
    {opcode: 'acc', value: 3},
    {opcode: 'jmp', value: -3},
    {opcode: 'acc', value: -99},
    {opcode: 'acc', value: 1},
    {opcode: 'jmp', value: -4},
    {opcode: 'acc', value: 6}
  ]

  puts(run_instructions(instructions)[:accumulator])
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  instructions = get_instructions_from_file('day8_input.txt')
  puts(run_instructions(instructions)[:accumulator])
end

def part_2_example
  puts("PART 2 EXAMPLE SOLUTION:")
  instructions = [
    {opcode: 'nop', value: 0},
    {opcode: 'acc', value: 1},
    {opcode: 'jmp', value: 4},
    {opcode: 'acc', value: 3},
    {opcode: 'jmp', value: -3},
    {opcode: 'acc', value: -99},
    {opcode: 'acc', value: 1},
    {opcode: 'jmp', value: -4},
    {opcode: 'acc', value: 6}
  ]

  puts(fix_instructions(instructions))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  instructions = get_instructions_from_file('day8_input.txt')
  puts(fix_instructions(instructions))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()