#!/usr/bin/env ruby

class Moon
  attr_accessor :id
  attr_accessor :pos
  attr_accessor :vel
  attr_accessor :gravity

  def initialize(pos, id)
    @id = id
    @pos = pos
    @vel = [0, 0, 0]
    @gravity = [0, 0, 0]
  end

  def calculate_gravity(moons)
    moons.each do |moon|
      next if @id == moon.id

      for i in 0...@gravity.length
        delta = 0
        if @pos[i] < moon.pos[i]
          delta = 1
        elsif @pos[i] > moon.pos[i]
          delta = -1
        end

        @gravity[i] += delta
      end
    end

    # puts "moon #{@id} gravity: #{@gravity.join(',')}"
  end

  def apply_gravity()
    # puts "moon #{@id} applying gravity #{@gravity.join(',')} to vel #{@vel.join(',')}"
    @vel = [@vel[0] + @gravity[0], @vel[1] + @gravity[1], @vel[2] + @gravity[2]]
    @gravity = [0, 0, 0]
  end

  def step()
    @pos = [@pos[0] + @vel[0], @pos[1] + @vel[1], @pos[2] + @vel[2]]
  end

  def potential_energy
    @pos[0].abs + @pos[1].abs + @pos[2].abs
  end

  def kinetic_energy
    @vel[0].abs + @vel[1].abs + @vel[2].abs
  end

  def total_energy
    potential_energy() * kinetic_energy()
  end

  def state_string()
    "pos: [#{@pos.join(',')}], vel: [#{@vel.join(',')}], gravity: #{@gravity.join(',')}"
  end

  def dimension_state(d)
    "pos: [#{@pos[d]}], vel: [#{@vel[d]}]}"
  end
end

def total_system_energy(moons, steps)
  for i in 0...steps
    moons.each do |moon|
      moon.calculate_gravity(moons)
    end

    moons.each do |moon|
      moon.apply_gravity()
      moon.step()
    end
  end

  total_energy_sum = 0

  moons.each do |moon|
    total_energy_sum += moon.total_energy()
  end

  total_energy_sum
end

def lcm(a, b)
  gcd = 1
  potential_max = [a, b].min
  for i in 1..potential_max
    gcd = i if a % i == 0 && b % i == 0
  end

  (a * b) / gcd
end

def get_orbital_period(moons)
  #arbitrary upper limit
  previous_states = [{}, {}, {}]
  orbital_periods = []
  for i in 0...1000000000
    states = [[], [], []]
    moons.each do |moon|
      for d in 0...3
        states[d] << moon.dimension_state(d)
      end
      moon.calculate_gravity(moons)
    end

    for d in 0...3
      combined_states = states[d].join('|')
      if !previous_states[d][combined_states].nil? && orbital_periods[d].nil?
        orbital_periods[d] = i
      end

      previous_states[d][combined_states] = i
    end

    break if orbital_periods.compact.length == 3

    moons.each do |moon|
      moon.apply_gravity()
      moon.step()
    end
  end

  lcm(lcm(orbital_periods[0], orbital_periods[1]), orbital_periods[2])
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  moons = [
    Moon.new([-1, 0, 2], 0),
    Moon.new([2, -10, -7], 1),
    Moon.new([4, -8, 8], 2),
    Moon.new([3, 5, -1], 3)
  ]
  puts(total_system_energy(moons, 10))

  moons = [
    Moon.new([-8, -10, 0], 0),
    Moon.new([5, 5, 10], 1),
    Moon.new([2, -7, 3], 2),
    Moon.new([9, -8, -3], 3)
  ]
  puts(total_system_energy(moons, 100))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  moons = [
    Moon.new([16, -11, 2], 0),
    Moon.new([0, -4, 7], 1),
    Moon.new([6, 4, -10], 2),
    Moon.new([-3, -2, -4], 3)
  ]
  puts(total_system_energy(moons, 1000))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  moons = [
    Moon.new([-1, 0, 2], 0),
    Moon.new([2, -10, -7], 1),
    Moon.new([4, -8, 8], 2),
    Moon.new([3, 5, -1], 3)
  ]
  puts(get_orbital_period(moons))

  moons = [
    Moon.new([-8, -10, 0], 0),
    Moon.new([5, 5, 10], 1),
    Moon.new([2, -7, 3], 2),
    Moon.new([9, -8, -3], 3)
  ]
  puts(get_orbital_period(moons))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  moons = [
    Moon.new([16, -11, 2], 0),
    Moon.new([0, -4, 7], 1),
    Moon.new([6, 4, -10], 2),
    Moon.new([-3, -2, -4], 3)
  ]
  puts(get_orbital_period(moons))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()