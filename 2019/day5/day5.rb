#!/usr/bin/env ruby

def get_program_from_file(filename)

  File.open(filename, "r") do |file|
    file.each_line do |line|
      return line.gsub(/[\s+]+/, '').split(',').map(&:to_i)
    end
  end

  []
end

def get_value(program, value, mode)
  if mode == 0
    return program[value]
  end

  return value
end

def execute_instruction(program, ip, input)
  instruction = program[ip]
  opcode = instruction % 100
  param_modes = [(instruction / 100) % 10, (instruction / 1000) % 10, (instruction / 10000) % 10]
  # puts "executing instruction: #{instruction}. opcode = #{opcode}, param_modes[0] = #{param_modes[0]}, param_modes[1] = #{param_modes[1]}, param_modes[2] = #{param_modes[2]}"

  case opcode
  when 1
    param1 = get_value(program, program[ip + 1], param_modes[0])
    param2 = get_value(program, program[ip + 2], param_modes[1])
    program[program[ip + 3]] = param1 + param2
  when 2
    param1 = get_value(program, program[ip + 1], param_modes[0])
    param2 = get_value(program, program[ip + 2], param_modes[1])
    program[program[ip + 3]] = param1 * param2
  when 3
    program[program[ip + 1]] = input
    return ip + 2
  when 4
    puts("output: #{get_value(program, program[ip + 1], param_modes[0])}")
    return ip + 2
  when 5
    param1 = get_value(program, program[ip + 1], param_modes[0])
    param2 = get_value(program, program[ip + 2], param_modes[1])

    if param1 != 0
      return param2
    end

    return ip + 3
  when 6
    param1 = get_value(program, program[ip + 1], param_modes[0])
    param2 = get_value(program, program[ip + 2], param_modes[1])

    if param1 == 0
      return param2
    end

    return ip + 3
  when 7
    param1 = get_value(program, program[ip + 1], param_modes[0])
    param2 = get_value(program, program[ip + 2], param_modes[1])
    program[program[ip + 3]] = (param1 < param2 ? 1 : 0)
  when 8
    param1 = get_value(program, program[ip + 1], param_modes[0])
    param2 = get_value(program, program[ip + 2], param_modes[1])
    program[program[ip + 3]] = (param1 == param2 ? 1 : 0)
  when 99
    # Halt by advancing IP past program length
    return program.length
  else
    puts("SOMETHING WENT WRONG! instruction = #{instruction}, ip = #{ip}")
    return program.length
  end

  return ip + 4
end

def run_program(program, input)
  ip = 0

  while ip < program.length
    instruction = program[ip]
    ip = execute_instruction(program, ip, input)
  end

  "Halt!"
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  puts(run_program([3,0,4,0,99], 999))
  program = [1002,4,3,4,33]
  run_program(program, 0)
  puts(program[4])
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  file_input = get_program_from_file("day5_input.txt")
  puts(run_program(file_input, 1))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  puts(run_program([3,9,8,9,10,9,4,9,99,-1,8], 7))
  puts(run_program([3,9,8,9,10,9,4,9,99,-1,8], 8))
  puts(run_program([3,9,8,9,10,9,4,9,99,-1,8], 9))

  puts(run_program([3,9,7,9,10,9,4,9,99,-1,8], 7))
  puts(run_program([3,9,7,9,10,9,4,9,99,-1,8], 8))
  puts(run_program([3,9,7,9,10,9,4,9,99,-1,8], 9))

  puts(run_program([3,3,1108,-1,8,3,4,3,99], 7))
  puts(run_program([3,3,1108,-1,8,3,4,3,99], 8))
  puts(run_program([3,3,1108,-1,8,3,4,3,99], 9))

  puts(run_program([3,3,1107,-1,8,3,4,3,99], 7))
  puts(run_program([3,3,1107,-1,8,3,4,3,99], 8))
  puts(run_program([3,3,1107,-1,8,3,4,3,99], 9))

  puts(run_program([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], 0))
  puts(run_program([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], 1))

  puts(run_program([3,3,1105,-1,9,1101,0,0,12,4,12,99,1], 0))
  puts(run_program([3,3,1105,-1,9,1101,0,0,12,4,12,99,1], 1))

  puts(run_program([3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99], 7))
  puts(run_program([3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99], 8))
  puts(run_program([3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99], 9))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  file_input = get_program_from_file("day5_input.txt")
  puts(run_program(file_input, 5))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()
