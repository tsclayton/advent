#!/usr/bin/env ruby

class Bot
  attr_accessor :pos
  attr_accessor :radius

  def initialize(pos, radius)
    @pos = pos
    @radius = radius
  end

  def distance(bot2)
    (pos[0] - bot2.pos[0]).abs + (pos[1] - bot2.pos[1]).abs + (pos[2] - bot2.pos[2]).abs
  end

  def intersects(bot2)
    distance(bot2) <= (radius + bot2.radius)
  end

  def is_in_range(bot2)
    distance(bot2) <= radius
  end
end

def get_bots_from_file(filename)
  bots = []

  File.read(filename).split("\n").each do |line|
    numbers = line.scan(/-?[0-9]+/).map(&:to_i)
    bots << Bot.new([numbers[0], numbers[1], numbers[2]], numbers[3])
  end

  bots
end

def get_strongest_bot(bots)
  strongest_bot = nil

  bots.each do |bot|
    strongest_bot = bot if strongest_bot.nil? || strongest_bot.radius < bot.radius
  end

  strongest_bot
end

def bots_in_strongest_radius(bots)
  strongest_bot = get_strongest_bot(bots)

  bot_count = 0

  bots.each do |bot|
    bot_count += 1 if strongest_bot.is_in_range(bot)
  end

  bot_count
end

def most_saturated_distance(bots)
  bot_buddies = {}

  for i in 0...bots.length
    bot_buddies[i] = []

    for j in 0...bots.length
      next if i == j

      bot_buddies[i] << j if bots[i].intersects(bots[j])
    end

    bot_buddies[i].sort
  end

  largest_collision_group = []
  bot_buddies.each do |bot, buddies|
    collision_group = bot_buddies[bot] + [bot]

    buddies.each do |buddy|
      collision_group = collision_group & (bot_buddies[buddy] + [buddy])
      break if collision_group.length < largest_collision_group.length
    end

    if collision_group.length > largest_collision_group.length
      largest_collision_group = collision_group
    end
  end

  largest_collision_group.map { |b| bots[b].pos.map(&:abs).sum - bots[b].radius }.max
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  bots = [
    Bot.new([0, 0, 0], 4),
    Bot.new([1, 0, 0], 1),
    Bot.new([4, 0, 0], 3),
    Bot.new([0, 2, 0], 1),
    Bot.new([0, 5, 0], 3),
    Bot.new([0, 0, 3], 1),
    Bot.new([1, 1, 1], 1),
    Bot.new([1, 1, 2], 1),
    Bot.new([1, 3, 1], 1)
  ]
  puts(bots_in_strongest_radius(bots))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  bots = get_bots_from_file('day23_input.txt')
  puts(bots_in_strongest_radius(bots))
end

def part_2_example
  puts("PART 2 EXAMPLE SOLUTION:")
  bots = [
    Bot.new([10,12,12], 2),
    Bot.new([12,14,12], 2),
    Bot.new([16,12,12], 4),
    Bot.new([14,14,14], 6),
    Bot.new([50,50,50], 200),
    Bot.new([10,10,10], 5)
  ]
  puts(most_saturated_distance(bots))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  bots = get_bots_from_file('day23_input.txt')
  puts(most_saturated_distance(bots))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()
