#!/usr/bin/env ruby

def get_seating_map_from_file(filename)
  File.read(filename).split("\n")
end

def conways_game_of_thrones(seating_map)
  new_seating_map = []

  for y in 0...seating_map.length
    row = ''

    for x in 0...seating_map[y].length
      if seating_map[y][x] == '.'
        row << '.'
        next
      end

      occupied_adjacents = 0
      break_early = false

      for ay in -1..1
        for ax in  -1..1
          adjacent_x = x + ax
          adjacent_y = y + ay

          next if adjacent_y < 0 || adjacent_y >= seating_map.length || adjacent_x < 0 || adjacent_x >= seating_map[y].length || (ax == 0 && ay == 0)

          occupied_adjacents += 1 if seating_map[adjacent_y][adjacent_x] == '#'
          break_early = seating_map[y][x] == 'L' && occupied_adjacents > 0 || seating_map[y][x] == '#' && occupied_adjacents >= 4
          break if break_early
        end

        break if break_early
      end

      new_seat = seating_map[y][x]
      new_seat = '#' if seating_map[y][x] == 'L' && occupied_adjacents == 0
      new_seat = 'L' if seating_map[y][x] == '#' && occupied_adjacents >= 4

      row << new_seat
    end

    new_seating_map << row
  end

  new_seating_map
end

def conways_occupied_equilibrium_seats(seating_map)
  while true
    old_state = seating_map.join('|')
    seating_map = conways_game_of_thrones(seating_map)
    if seating_map.join('|') == old_state
      break
    end
  end

  seating_map.join('').chars.map { |char| char == '#' ? 1 : 0 }.sum
end

def construct_seat_sight_map(seating_map)
  seat_sight_map = {}

  directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

  for y in 0...seating_map.length
    for x in 0...seating_map[y].length
      seats_in_sight = []

      directions.each do |dir|
        next_pos = [x, y]

        while true
          next_pos = [next_pos[0] + dir[0], next_pos[1] + dir[1]]
          break if next_pos[1] < 0 || next_pos[1] >= seating_map.length || next_pos[0] < 0 || next_pos[0] >= seating_map[y].length

          # Seats should be empty when this is constructed, but filled seats are technically correct
          if seating_map[next_pos[1]][next_pos[0]] == 'L' || seating_map[next_pos[1]][next_pos[0]] == '#'
            seats_in_sight << next_pos
            break
          end
        end
      end

      seat_sight_map[[x, y]] = seats_in_sight
    end
  end

  seat_sight_map
end

def seat_sight_step(seating_map, seat_sight_map)
  new_seating_map = []

  for y in 0...seating_map.length
    row = ''

    for x in 0...seating_map[y].length
      if seating_map[y][x] == '.'
        row << '.'
        next
      end

      occupied_adjacents = 0

      seat_sight_map[[x, y]].each do |seat_pos|
        occupied_adjacents += 1 if seating_map[seat_pos[1]][seat_pos[0]] == '#'
        break if seating_map[y][x] == 'L' && occupied_adjacents > 0 || seating_map[y][x] == '#' && occupied_adjacents >= 5
      end

      new_seat = seating_map[y][x]
      new_seat = '#' if seating_map[y][x] == 'L' && occupied_adjacents == 0
      new_seat = 'L' if seating_map[y][x] == '#' && occupied_adjacents >= 5

      row << new_seat
    end

    new_seating_map << row
  end

  new_seating_map
end


def seat_sight_occupied_equilibrium_seats(seating_map)
  seat_sight_map = construct_seat_sight_map(seating_map)

  while true
    old_state = seating_map.join('|')
    seating_map = seat_sight_step(seating_map, seat_sight_map)
    if seating_map.join('|') == old_state
      break
    end
  end

  seating_map.join('').chars.map { |char| char == '#' ? 1 : 0 }.sum
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  seating_map = [
    'L.LL.LL.LL',
    'LLLLLLL.LL',
    'L.L.L..L..',
    'LLLL.LL.LL',
    'L.LL.LL.LL',
    'L.LLLLL.LL',
    '..L.L.....',
    'LLLLLLLLLL',
    'L.LLLLLL.L',
    'L.LLLLL.LL'
  ]
  puts(conways_occupied_equilibrium_seats(seating_map))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  seating_map = get_seating_map_from_file('day11_input.txt')
  puts(conways_occupied_equilibrium_seats(seating_map))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:') 
  seating_map = [
    'L.LL.LL.LL',
    'LLLLLLL.LL',
    'L.L.L..L..',
    'LLLL.LL.LL',
    'L.LL.LL.LL',
    'L.LLLLL.LL',
    '..L.L.....',
    'LLLLLLLLLL',
    'L.LLLLLL.L',
    'L.LLLLL.LL'
  ]
  puts(seat_sight_occupied_equilibrium_seats(seating_map))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  seating_map = get_seating_map_from_file('day11_input.txt')
  puts(seat_sight_occupied_equilibrium_seats(seating_map))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()