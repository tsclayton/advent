#!/usr/bin/env ruby

require 'set'

def get_decks_from_file(filename)
  deck_1 = []
  deck_2 = []

  player_1 = true

  File.read(filename).split("\n").each do |line|
    next if line.empty?

    if line == "Player 1:"
      player_1 = true
    elsif line == "Player 2:"
      player_1 = false
    else
      if player_1
        deck_1 << line.to_i
      else
        deck_2 << line.to_i
      end
    end
  end

  {deck_1: deck_1, deck_2: deck_2}
end

def calculate_score(deck)
  score = 0

  for i in 0...deck.length
    score += (deck[i] * (deck.length - i))
  end

  score
end

def play_combat(deck_1, deck_2)
  while deck_1.length > 0 && deck_2.length > 0
    deck_1_card = deck_1.shift
    deck_2_card = deck_2.shift

    if deck_1_card > deck_2_card
      deck_1 += [deck_1_card, deck_2_card]
    else
      deck_2 += [deck_2_card, deck_1_card]
    end
  end

  calculate_score(deck_1.length > 0 ? deck_1 : deck_2)
end

def get_state(deck_1, deck_2)
  "#{deck_1.join(',')}|#{deck_2.join(',')}"
end

def play_recursive_combat(deck_1, deck_2)
  cache = {}

  while deck_1.length > 0 && deck_2.length > 0
    state = get_state(deck_1, deck_2)

    break if cache[state]

    cache[state] = true

    deck_1_card = deck_1.shift
    deck_2_card = deck_2.shift

    deck_1_wins = false
    if deck_1.length >= deck_1_card && deck_2.length >= deck_2_card
      deck_1_wins = play_recursive_combat(deck_1.take(deck_1_card), deck_2.take(deck_2_card))[:player_1_wins]
    else
      deck_1_wins = deck_1_card > deck_2_card
    end

    if deck_1_wins
      deck_1 += [deck_1_card, deck_2_card]
    else
      deck_2 += [deck_2_card, deck_1_card]
    end
  end

  player_1_wins = deck_1.length > 0
  {player_1_wins: player_1_wins, deck: player_1_wins ? deck_1 : deck_2}
end

def winning_recursive_score(deck_1, deck_2)
  results = play_recursive_combat(deck_1, deck_2)
  calculate_score(results[:deck])
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  puts(play_combat([9, 2, 6, 3, 1], [5, 8, 4, 7, 10]))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  decks = get_decks_from_file('day22_input.txt')
  puts(play_combat(decks[:deck_1], decks[:deck_2]))
end

def part_2_examples
  puts('PART 2 EXAMPLE SOLUTIONS:')
  # Should terminate
  puts(winning_recursive_score([43, 19], [2, 29, 14]))
  puts(winning_recursive_score([9, 2, 6, 3, 1], [5, 8, 4, 7, 10]))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  decks = get_decks_from_file('day22_input.txt')
  puts(winning_recursive_score(decks[:deck_1], decks[:deck_2]))
end

part_1_example()
part_1_final()
part_2_examples()
part_2_final()