#!/usr/bin/env ruby

def get_grouped_answers_from_file(filename)
  grouped_answers = []
  group = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      if line.length > 1
        group << line.chomp("\n")
      else
        # newline
        grouped_answers << group
        group = []
      end
    end
  end

  grouped_answers << group if group.length > 0
  grouped_answers
end

def anyone_yes_count_sum(grouped_answers)
  sum = 0

  grouped_answers.each do |group|
    answered_questions = {}

    group.each do |answers|
      for i in 0...answers.length
        answered_questions[answers[i]] = true
      end
    end

    sum += answered_questions.keys.length
  end

  sum
end

def everyone_yes_count_sum(grouped_answers)
  sum = 0

  grouped_answers.each do |group|
    answered_questions = {}

    everyones_answers = group[0]
    for i in 1...group.length
      everyones_answers = everyones_answers.tr("^[#{group[i]}]", '')
    end

    sum += everyones_answers.length
  end

  sum
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  grouped_answers = [
    ['abc'],
    ['a', 'b', 'c'],
    ['ab','ac'],
    ['a','a','a','a'],
    ['b']
  ]
  puts(anyone_yes_count_sum(grouped_answers))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  grouped_answers = get_grouped_answers_from_file("day6_input.txt")
  puts(anyone_yes_count_sum(grouped_answers))
end

def part_2_example
  puts("PART 2 EXAMPLE SOLUTION:")
  grouped_answers = [
    ['abc'],
    ['a', 'b', 'c'],
    ['ab','ac'],
    ['a','a','a','a'],
    ['b']
  ]
  puts(everyone_yes_count_sum(grouped_answers))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  grouped_answers = get_grouped_answers_from_file("day6_input.txt")
  puts(everyone_yes_count_sum(grouped_answers))
end

part_1_example()
part_1_final()
part_2_example()  
part_2_final()