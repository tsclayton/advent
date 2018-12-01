#!/usr/bin/env ruby

class Particle
  attr_accessor :position
  attr_accessor :velocity
  attr_accessor :acceleration

  def initialize(position, velocity, acceleration)
    @position = position
    @velocity = velocity
    @acceleration = acceleration
  end

  def update_velocity()
    @velocity[0] += @acceleration[0]
    @velocity[1] += @acceleration[1]
    @velocity[2] += @acceleration[2]
  end

  def update_position
    @position[0] += @velocity[0]
    @position[1] += @velocity[1]
    @position[2] += @velocity[2]
  end
end

def parse_file(filename)
  particles = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      numbers = line.gsub(/[^0-9,-]/, '').split(',').map(&:to_f)
      particles << Particle.new(numbers[0...3], numbers[3...6], numbers[6...9])
    end
  end

  particles
end

def abs_sum(vector)
  vector.map(&:abs).reduce(:+)
end

def particle_closest_to_zero(particles)
  closest_i = nil

  for i in 0...particles.length
    particle = particles[i]

    if closest_i == nil || abs_sum(particle.acceleration) < abs_sum(particles[closest_i].acceleration)
      closest_i = i
    elsif abs_sum(particle.acceleration) == abs_sum(particles[closest_i].acceleration)
      if abs_sum(particle.velocity) < abs_sum(particles[closest_i].velocity) ||
        (abs_sum(particle.velocity) == abs_sum(particles[closest_i].velocity) && abs_sum(particle.position) < abs_sum(particles[closest_i].position))
        closest_i = i
      end
    end
  end

  closest_i
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = [Particle.new([3,0,0], [2,0,0], [-1,0,0]), Particle.new([4,0,0], [0,0,0], [-2,0,0])]
  puts(particle_closest_to_zero(example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day20_input.txt")
  puts(particle_closest_to_zero(file_input))
end

# Solves for t in the x direction to get potential collision times to compare with
def get_possible_collision_times(p1, p2, v1, v2, a1, a2)
  if a1 != a2
    # Quadratic formula time, baby!
    a = 0.5 * (a1 - a2)
    b = (v1 + (0.5 * a1) - v2 - (0.5 * a2))
    c = (p1 - p2)

    return [1/0.0] if (b ** 2) - (4 * a * c) < 0

    time1 = (-b + Math.sqrt((b ** 2) - (4 * a * c))) / (2 * a)
    time2 = (-b - Math.sqrt((b ** 2) - (4 * a * c))) / (2 * a)

    return [time1, time2]
  elsif v1 != v2
    time = (p1 - p2) / (v2 - v1)
    return [time.to_f]
  elsif p1 != p2
    # Can't intersect, return Infinity
    return [1/0.0]
  end

  return [0.0]
end

# Gets position of particle given the tick number
def get_position_at_time(particle, time)
  x = particle.position[0] + ((particle.velocity[0] + (0.5 * particle.acceleration[0])) * time) + (0.5 * particle.acceleration[0] * (time ** 2))
  y = particle.position[1] + ((particle.velocity[1] + (0.5 * particle.acceleration[1])) * time) + (0.5 * particle.acceleration[1] * (time ** 2))
  z = particle.position[2] + ((particle.velocity[2] + (0.5 * particle.acceleration[2])) * time) + (0.5 * particle.acceleration[2] * (time ** 2))
  [x, y, z]
end

# "Funny" story about this one: Before I realized I wasn't parsing negative numbers correctly from the input file, I assumed the collision times were large enough such that
# a simple update loop solution (like the one below) was untenable. Thus, I came up with a solution that uses algebra to find all possible collision times (even using the quadratic formula at times!).
# It's slower than the update loop solution below, but it guarantees all collisions covered, so I decided to keep it.
# There is a way to optimize this solution even further, and it would go something like this:
#  1) assign an id to each particle and change the collision hash to {id => smallest_collision_time}
#  2) if a particle collides with another particle, only record the collision if it's smaller than the current smallest_collision_time in the hash
#  3) thus, only valid collisions are stored in the collisions hash, and thus all the particles can be removed at once

def math_based_particles_after_collisions(particles)
  while true
    collisions = {}

    for i in 0...particles.length
      p1 = particles[i]
      for j in (i + 1)...particles.length
        p2 = particles[j]
        possible_collision_times =
          get_possible_collision_times(p1.position[0], p2.position[0], p1.velocity[0], p2.velocity[0], p1.acceleration[0], p2.acceleration[0])
        smallest_collision_time = nil

        possible_collision_times.each do |time|
          next if time.nan? || time.infinite? || time < 0 || time.floor != time

          if get_position_at_time(p1, time).eql?(get_position_at_time(p2, time))
            smallest_collision_time = time if smallest_collision_time == nil || time < smallest_collision_time
          end
        end

        if smallest_collision_time != nil
          collisions[smallest_collision_time] ||= []
          collisions[smallest_collision_time] = (collisions[smallest_collision_time] + [p1, p2]).uniq
        end
      end
    end

    break if collisions.empty?

    # Remove at earliest collision time in case a particle potentially collides with another one in the future
    earliest_collisions = collisions[collisions.keys.sort[0]]
    particles -= earliest_collisions
  end

  particles.length
end

# The much easier solution with a simple update loop that runs for an arbitrarily long time
def particles_after_collisions(particles)
  for i in 0...1000
    positions = {}
    particles_to_delete = []

    particles.each do |particle|
      position_string = particle.position.join(',')
      positions[position_string] ||= []
      positions[position_string] << particle
      if positions[position_string].length > 1
        # only add first particle once
        particles_to_delete << positions[position_string][0] if positions[position_string].length == 2
        particles_to_delete << particle
      end
    end

    if particles_to_delete.length > 0
      particles -= particles_to_delete
    end

    break if particles.length == 1

    particles.each do |particle|
      particle.update_velocity()
      particle.update_position()
    end
  end

  particles.length
end

def part_2
  puts("EXAMPLE SOLUTION:")
  example_input = [
    Particle.new([-6,0,0], [3,0,0], [0,0,0]),
    Particle.new([-4,0,0], [2,0,0], [0,0,0]),
    Particle.new([-2,0,0], [1,0,0], [0,0,0]),
    Particle.new([3,0,0], [-1,0,0], [0,0,0])
  ]

  puts(math_based_particles_after_collisions(example_input))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day20_input.txt")
  puts(math_based_particles_after_collisions(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
