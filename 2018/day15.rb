#!/usr/bin/env ruby

class Generator
  attr_accessor :factor
  attr_accessor :curr_value

  def initialize(factor, starting_value)
    @factor = factor
    @curr_value = starting_value
  end

  def generate_next_value()
    @curr_value = (@factor * @curr_value) % 2147483647
  end

  def get_lower_16_bits()
    @curr_value & 0b00000000000000001111111111111111
  end
end

def num_matches(gen_a, gen_b, iterations)
  matches = 0

  for i in 0...iterations
    gen_a.generate_next_value()
    gen_b.generate_next_value()
    matches += 1 if gen_a.get_lower_16_bits() == gen_b.get_lower_16_bits()
  end

  matches
end

def num_matches_part_2(gen_a, gen_b, iterations)
  matches = 0

  for i in 0...iterations
    while true
      gen_a.generate_next_value()
      break if (gen_a.curr_value % 4) == 0
    end

    while true
      gen_b.generate_next_value()
      break if (gen_b.curr_value % 8) == 0
    end

    matches += 1 if gen_a.get_lower_16_bits() == gen_b.get_lower_16_bits()
  end

  matches
end

def part_1
  puts("EXAMPLE SOLUTION:")
  gen_a = Generator.new(16807, 65)
  gen_b = Generator.new(48271, 8921)
  puts(num_matches(gen_a, gen_b, 5))
  puts("INPUT SOLUTION:")
  gen_a = Generator.new(16807, 679)
  gen_b = Generator.new(48271, 771)
  puts(num_matches(gen_a, gen_b, 40_000_000))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  gen_a = Generator.new(16807, 65)
  gen_b = Generator.new(48271, 8921)
  puts(num_matches_part_2(gen_a, gen_b, 5_000_000))
  puts("INPUT SOLUTION:")
  gen_a = Generator.new(16807, 679)
  gen_b = Generator.new(48271, 771)
  puts(num_matches_part_2(gen_a, gen_b, 5_000_000))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
