#!/usr/bin/env ruby

def transform(x, n)
  y = 1

  while n > 0
    y = y * x % 20201227 if n.odd?
    n = n / 2
    x = x * x % 20201227
  end

  y
end

def brute_force(card_public_key, door_public_key)
  card_loop_size = nil  
  door_loop_size = nil

  i = 0

  while true
    value = transform(7, i)
    if value  == card_public_key
      card_loop_size = i
      break
    elsif value == door_public_key
      door_loop_size = i
      break
    end
    i += 1
  end

  !card_loop_size.nil? ? transform(door_public_key, card_loop_size) : transform(card_public_key, door_loop_size)
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  puts(brute_force(5764801, 17807724))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  puts(brute_force(17607508, 15065270))
end

part_1_example()
part_1_final()