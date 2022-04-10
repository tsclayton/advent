#!/usr/bin/env ruby

def pow_mod(x, n, m)
  y = 1

  while n > 0
    y = y * x % m if n.odd?
    n = n / 2
    x = x * x % m
  end

  y
end

def inverse(x, m)
  pow_mod(x, m - 2, m)
end

def first_capsule_time(discs)
  m = discs.map {|d| d[:num_positions]}.reduce(:*)

  ms = []
  ys = []
  as = []

  for i in 0...discs.length
    disc = discs[i]
    depth = i + 1
    mi = (discs - [disc]).map {|d| d[:num_positions]}.reduce(:*)
    ms << mi
    ys << inverse(mi, disc[:num_positions])
    as << (-disc[:starting_position] - depth)
  end

  total = 0

  for i in 0...discs.length
    total += (as[i] * ms[i] * ys[i])
  end

  total % m
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTIONS:')
  discs = [
    {num_positions: 5, starting_position: 4},
    {num_positions: 2, starting_position: 1}
  ]
  puts(first_capsule_time(discs))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  discs = [
    {num_positions: 13, starting_position: 1},
    {num_positions: 19, starting_position: 10},
    {num_positions: 3, starting_position: 2},
    {num_positions: 7, starting_position: 1},
    {num_positions: 5, starting_position: 3},
    {num_positions: 17, starting_position: 5}
  ]
  puts(first_capsule_time(discs))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  discs = [
    {num_positions: 13, starting_position: 1},
    {num_positions: 19, starting_position: 10},
    {num_positions: 3, starting_position: 2},
    {num_positions: 7, starting_position: 1},
    {num_positions: 5, starting_position: 3},
    {num_positions: 17, starting_position: 5},
    {num_positions: 11, starting_position: 0}
  ]
  puts(first_capsule_time(discs))
end

part_1_example()
part_1_final()
part_2_final()