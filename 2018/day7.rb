#!/usr/bin/env ruby

def get_instructions_from_file(filename)
  instructions = {}

  File.open(filename, "r") do |file|
    file.each_line do |line|
      split_line = line.split(' ')
      prerequisite = split_line[1]
      step = split_line[7]

      instructions[step] ||= []
      instructions[prerequisite] ||= []
      instructions[step] << prerequisite
    end
  end

  instructions
end

def get_step_order(instructions)
  sorted_steps = instructions.keys.sort
  step_order = ''

  while !instructions.empty?
    sorted_steps.each do |step|
      if !instructions[step].nil? && instructions[step].empty?
        instructions.delete(step)
        step_order << step

        instructions.values.each do |prerequisites|
          prerequisites.delete(step)
        end

        break
      end
    end
  end

  step_order
end

class Worker
  attr_accessor :current_task
  attr_accessor :seconds_to_complete

  def initialize()
    @current_task = nil
    @seconds_to_complete = 0
  end

  def is_available()
    @seconds_to_complete == 0
  end

  def tick()
    @seconds_to_complete -= 1
  end
end

# Probably should've broken this up into smaller functions, but ¯\_(ツ)_/¯
def get_completion_time(instructions, num_workers)
  workers = []
  sorted_steps = instructions.keys.sort

  for i in 0...num_workers
    workers << Worker.new()
  end

  total_seconds = 0

  while true
    is_worker_available = false
    all_workers_free = true

    workers.each_with_index do |worker, i|
      if worker.is_available()
        is_worker_available = true
      else
        worker.tick()
        if worker.is_available()
          instructions.values.each do |prerequisites|
            prerequisites.delete(worker.current_task)
          end

          is_worker_available = true
        else
          all_workers_free = false
        end
      end
    end

    # Also check that no workers have a current task
    break if instructions.empty? && all_workers_free

    if is_worker_available
      sorted_steps.each do |step|
        if !instructions[step].nil? && instructions[step].empty?
          available_worker = nil

          workers.each do |worker|
            if worker.is_available()
              available_worker = worker
              break
            end
          end

          if !available_worker.nil?
            available_worker.current_task = step
            available_worker.seconds_to_complete = (step.ord - 64) + 60
            # Remove it from the list so another worker doesn't start working on it
            instructions.delete(step)
          end
        end
      end
    end

    total_seconds += 1
  end

  total_seconds
end

def part_1
  puts("EXAMPLE SOLUTIONS:")
  example_input = get_instructions_from_file("day7_example.txt")
  puts(get_step_order(example_input))
  puts("INPUT SOLUTION:")
  file_input = get_instructions_from_file("day7_input.txt")
  puts(get_step_order(file_input))
end


def part_2
  puts("EXAMPLE SOLUTIONS:")
  example_input = get_instructions_from_file("day7_example.txt")
  puts(get_completion_time(example_input, 2))
  puts("INPUT SOLUTION:")
  file_input = get_instructions_from_file("day7_input.txt")
  puts(get_completion_time(file_input, 5))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
