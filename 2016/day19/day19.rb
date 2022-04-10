#!/usr/bin/env ruby

class Elf
  attr_accessor :id
  attr_accessor :next_elf

  def initialize(id)
    @id = id
  end
end

def get_lucky_elf(num_elves)
  first_elf = Elf.new(1)

  prev_elf = first_elf

  for i in 1...num_elves
    elf = Elf.new(i + 1)
    prev_elf.next_elf = elf
    prev_elf = elf
  end

  prev_elf.next_elf = first_elf
  curr_elf = first_elf

  while curr_elf.id != curr_elf.next_elf.id
    next_elf = curr_elf.next_elf
    curr_elf.next_elf = next_elf.next_elf
    next_elf.next_elf = nil
    curr_elf = curr_elf.next_elf
  end

  curr_elf.id
end


def get_lucky_elf_arr(num_elves)
  elves = (1...(num_elves + 1)).to_a

  i = 0
  while elves.length > 1
    i = (i + 1) % elves.length
    elves.delete_at(i)
  end

  elves[0]
end

def get_lucky_elf_cross_circle(num_elves)
  elves = (1...(num_elves + 1)).to_a

  i = 0
  while elves.length > 1
    victim = (i + (elves.length / 2)) % elves.length
    elves.delete_at(victim)

    i += 1 if victim > i
    i = i % elves.length
  end

  elves[0]
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  puts(get_lucky_elf(5))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  puts(get_lucky_elf(3_004_953))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  puts(get_lucky_elf_2(5))
  puts(get_lucky_elf_cross_circle(5))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  puts get_lucky_elf_cross_circle(3_004_953)
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()