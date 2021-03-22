#!/usr/bin/env ruby

class Cup
  attr_accessor :next
  attr_accessor :value

  def initialize(value)
    @value = value
  end
end

def shuffle_cups(cup_values, moves)
  cups = []
  max_value = cup_values.max

  cup_lookup = {}
  for i in 0...cup_values.length
    cup = Cup.new(cup_values[i])
    cups << cup
    cup_lookup[cup.value] = cup

    cups[i - 1].next = cup if i > 0
  end

  cups[-1].next = cups[0]
  current_cup = cups[0]

  for move in 0...moves
    pickup_start = current_cup.next
    pickup_end = current_cup.next.next.next
    current_cup.next = pickup_end.next

    pickup_cups = [pickup_start.value, pickup_start.next.value, pickup_end.value]

    destination_cup = current_cup.value - 1
    destination_cup = max_value if destination_cup <= 0

    while pickup_cups.member?(destination_cup)
      destination_cup -= 1
      destination_cup = max_value if destination_cup <= 0
    end

    pickup_dest = cup_lookup[destination_cup]
    pickup_end.next = pickup_dest.next
    pickup_dest.next = pickup_start

    current_cup = current_cup.next
  end

  cup_lookup[1]
end

def cups_right_of_1_after_shuffle(cup_values, moves)
  cup_1 = shuffle_cups(cup_values, moves)

  output = ''
  current_cup = cup_1.next

  while current_cup.value != 1
    output << current_cup.value.to_s
    current_cup = current_cup.next
  end

  output
end

def two_right_after_super_shuffle(cup_values)
  cup_values += ((cup_values.max + 1)..1_000_000).to_a
  cup_1 = shuffle_cups(cup_values, 10_000_000)
  cup_1.next.value * cup_1.next.next.value
end

def part_1_examples
  puts('PART 1 EXAMPLE SOLUTIONS:')
  puts(cups_right_of_1_after_shuffle([3, 8, 9, 1, 2, 5, 4, 6, 7], 10))
  puts(cups_right_of_1_after_shuffle([3, 8, 9, 1, 2, 5, 4, 6, 7], 100))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  puts(cups_right_of_1_after_shuffle([3, 2, 7, 4, 6, 5, 1, 8, 9], 100))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  puts(two_right_after_super_shuffle([3, 8, 9, 1, 2, 5, 4, 6, 7]))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  puts(two_right_after_super_shuffle([3, 2, 7, 4, 6, 5, 1, 8, 9]))
end

part_1_examples()
part_1_final()
part_2_example()
part_2_final()
