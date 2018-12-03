#!/usr/bin/env ruby

class Claim
  attr_accessor :id
  attr_accessor :x
  attr_accessor :y
  attr_accessor :w
  attr_accessor :h

  def initialize(id, x, y, w, h)
    @id = id
    @x = x
    @y = y
    @w = w
    @h = h
  end
end

def parse_file(filename)
  claims = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      subbed_line = line.gsub(/[x,@:]/, ' ').gsub(/#/, '').gsub(/\s+/, ' ')
      numbers = subbed_line.split(' ').map(&:to_i)
      claims << Claim.new(numbers[0], numbers[1], numbers[2], numbers[3], numbers[4])
    end
  end

  claims
end

def gen_fabric_grid
  fabric = []

  for x in 0...1000
    fabric[x] = []
    for y in 0...1000
      fabric[x][y] = {id: 0, overlaps: 0}
    end
  end

  fabric
end

def apply_claims_to_fabric(claims)
  fabric = gen_fabric_grid()

  claims.each do |claim|
    for x in claim.x...(claim.x + claim.w)
      for y in claim.y...(claim.y + claim.h)
        fabric[x][y][:id] = claim.id
        fabric[x][y][:overlaps] += 1
      end
    end
  end

  fabric
end

def num_overlapping_inches(claims)
  claimed_fabric = apply_claims_to_fabric(claims)

  overlap_count = 0

  for x in 0...claimed_fabric.length
    for y in 0...claimed_fabric[x].length
      overlap_count += 1 if claimed_fabric[x][y][:overlaps] > 1
    end
  end

  overlap_count
end

def id_of_non_overlapping_claim(claims)
  claimed_fabric = apply_claims_to_fabric(claims)

  claims.each do |claim|
    overlaps = false

    for x in claim.x...(claim.x + claim.w)
      for y in claim.y...(claim.y + claim.h)
        if claimed_fabric[x][y][:overlaps] > 1
          overlaps = true
          break
        end
      end

      break if overlaps
    end

    return claim.id if !overlaps
  end

  for x in 0...claimed_fabric.length
    for y in 0...claimed_fabric[x].length
      return claimed_fabric[x][y][:id] if claimed_fabric[x][y][:overlaps] == 1
    end
  end

  0
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = [Claim.new(1, 1, 3, 4, 4), Claim.new(2, 3, 1, 4, 4), Claim.new(3, 5, 5, 2, 2)]
  puts(num_overlapping_inches(example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day3_input.txt")
  puts(num_overlapping_inches(file_input))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  example_input = [Claim.new(1, 1, 3, 4, 4), Claim.new(2, 3, 1, 4, 4), Claim.new(3, 5, 5, 2, 2)]
  puts(id_of_non_overlapping_claim(example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day3_input.txt")
  puts(id_of_non_overlapping_claim(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
