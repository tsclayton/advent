#!/usr/bin/env ruby

def marble_scores(num_players, last_marble_value)
  marbles = [0]
  lowest_marble_value = 0
  current_marble_index = 0
  current_marble_value = 1

  player_scores = Array.new(num_players, 0)
  current_player = 0

  while current_marble_value < last_marble_value
    if (current_marble_value % 23) == 0
      removed_marble_index = (current_marble_index - 7) % marbles.length
      removed_marble = marbles.delete_at(removed_marble_index)
      current_marble_index = removed_marble_index % marbles.length

      # Add current marble value and removed marble value to score
      player_scores[current_player] += current_marble_value + removed_marble
    else
      current_marble_index = (current_marble_index + 2) % (marbles.length)
      marbles.insert(current_marble_index, current_marble_value)
    end

    # puts marbles.join(' ')
    current_marble_value += 1
    current_player = (current_player + 1) % num_players
  end

  player_scores
end

def highest_player_score(num_players, last_marble_value)
  marble_scores(num_players, last_marble_value).max
end

def part_1
  puts("EXAMPLE SOLUTION:")
  puts(highest_player_score(9, 25))
  puts(highest_player_score(10, 1618))
  puts(highest_player_score(13, 7999))
  puts(highest_player_score(17, 1104))
  puts(highest_player_score(21, 6111))
  puts(highest_player_score(30, 5807))
  puts("INPUT SOLUTION:")
  puts(highest_player_score(486, 70833))
end

def part_2
  puts("INPUT SOLUTION:")
  # Just gonna run this in the background while I work out a way to optimize
  # My guess is the proper solution involves working out how either the scores or the marbles work out into a series
  # then use that to make a trivial solution without having to maintain a marbles array
  # Alternatively, a doubly linked list might make the solution computable as it would avoid expensive operations on massive arrays
  # If this comment is still here then this eventually completed and I just used the answer I got from that
  puts(highest_player_score(486, 7083300))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
