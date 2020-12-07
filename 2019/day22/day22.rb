#!/usr/bin/env ruby

def get_commands_from_file(filename)
  commands = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      commands << line
    end
  end

  commands
end

def shuffle_deck(deck_size, commands)
  deck = (0...deck_size).to_a

  commands.each do |command|
    if !command.index('stack').nil?
      deck = deck.reverse
    elsif !command.index('cut').nil?
      number = command.split(' ')[1].to_i
      if number >= 0
        deck = deck[number...deck.length] + deck[0...number]
      else
        deck = deck[(deck.length + number)...deck.length] + deck[0...(deck.length + number)]
      end
    elsif !command.index('increment').nil?
      increment = command.split(' ')[3].to_i
      table = Array.new(deck_size)
      for i in 0...deck.length
        table[(i * increment) % deck_size] = deck[i]
      end

      deck = table
    else
      puts "invalid command: #{command}"
    end
  end

  deck
end

def pow_mod(x, n, m)
  y = 1

  while n > 0
    y = y * x % m if n.odd?
    n = n / 2
    x = x * x % m
  end

  y
end

# Had to crib this solution off reddit because I haven't thought about Fermat or his little theorem in a literal decade.
class LCF
  attr_accessor :a
  attr_accessor :b

  def initialize(a, b, mod)
    @a = a
    @b = b
    @mod = mod
  end

  def evaluate(x)
    ((@a * x) + @b) % @mod
  end

  def inverse(x)
    inverse_a = pow_mod(a, @mod - 2, @mod)
    ((x - @b) * inverse_a) % @mod
  end

  def compose(c, d)
    new_a = (@a * c) % @mod
    new_b = ((@b * c) + d) % @mod
    @a = new_a
    @b = new_b
  end

  def pow_compose(k)
    new_a = (@a.pow(k)) % @mod
    new_b = ((@b * (1 - @a.pow(k))) / (1 - @a)) % @mod
  end
end

def pow_compose(lcf, k, mod)
  g = LCF.new(1, 0, mod)
  while k > 0
    g.compose(lcf.a, lcf.b) if k.odd?
    k = k / 2
    lcf.compose(lcf.a, lcf.b)
  end
  g
end

def mod_shuffle(deck_size, iterations, position, commands)
  composed_lcf = LCF.new(1, 0, deck_size)

  commands.each do |command|
    if !command.index('stack').nil?
      composed_lcf.compose(-1, -1)
    elsif !command.index('cut').nil?
      n = command.split(' ')[1].to_i
      composed_lcf.compose(1, -n)
    elsif !command.index('increment').nil?
      n = command.split(' ')[3].to_i
      composed_lcf.compose(n, 0)
    else
      puts "invalid command: #{command}"
    end
  end

  composed_lcf = pow_compose(composed_lcf, iterations, deck_size)
  composed_lcf.inverse(position)
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  commands = [
    'deal with increment 7',
    'deal into new stack',
    'deal into new stack'
  ]
  # Result: 0 3 6 9 2 5 8 1 4 7
  puts(shuffle_deck(10, commands).join(','))

  commands = [
    'cut 6',
    'deal with increment 7',
    'deal into new stack'
  ]
  # Result: 3 0 7 4 1 8 5 2 9 6
  puts(shuffle_deck(10, commands).join(','))

  commands = [
    'deal with increment 7',
    'deal with increment 9',
    'cut -2'
  ]
  # Result: 6 3 0 7 4 1 8 5 2 9
  puts(shuffle_deck(10, commands).join(','))

  commands = [
    'deal into new stack',
    'cut -2',
    'deal with increment 7',
    'cut 8',
    'cut -4',
    'deal with increment 7',
    'cut 3',
    'deal with increment 9',
    'deal with increment 3',
    'cut -1'
  ]
  # Result: 9 2 5 8 1 4 7 0 3 6
  puts(shuffle_deck(10, commands).join(','))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  commands = get_commands_from_file("day22_input.txt")
  puts(shuffle_deck(10_007, commands).index(2019))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  commands = get_commands_from_file("day22_input.txt")
  puts(mod_shuffle(119_315_717_514_047, 101_741_582_076_661, 2020, commands))
end

part_1_examples()
part_1_final()
part_2_final()