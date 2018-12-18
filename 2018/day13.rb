#!/usr/bin/env ruby

class Cart
  attr_accessor :coords
  attr_accessor :direction
  attr_accessor :next_intersection_turn

  attr_accessor :id
  attr_accessor :active

  def initialize(coords, direction)
    @coords = coords
    @direction = direction
    @next_intersection_turn = 'left'

    @active = true
  end

  def advance()
    @coords[0] += @direction[0]
    @coords[1] += @direction[1]
  end

  def get_next_coords()
    [@coords[0] + @direction[0], @coords[1] + @direction[1]]
  end

  def handle_intersection()
    case @next_intersection_turn
      when 'left'
        turn_left()
        @next_intersection_turn = 'straight'
      when 'straight'
        @next_intersection_turn = 'right'
      when 'right'
        turn_right()
        @next_intersection_turn = 'left'
    end
  end

  def turn_left()
    @direction = [@direction[1], -@direction[0]]
  end

  def turn_right()
    @direction = [-@direction[1], @direction[0]]
  end
end

def get_track_and_carts_from_file(filename)
  tracks = []
  carts = []

  y = 0

  File.open(filename, "r") do |file|
    file.each_line do |line|
      for x in 0...line.length
        char = line[x]

        tracks[x] ||= []

        if ['<', '>', 'v', '^'].include?(char)
          direction = []
          case char
            when '>'
              direction = [1, 0]
              tracks[x][y] = '-'
            when '<'
              direction = [-1, 0]
              tracks[x][y] = '-'
            when 'v'
              direction = [0, 1]
              tracks[x][y] = '|'
            when '^'
              direction = [0, -1]
              tracks[x][y] = '|'
          end

          carts << Cart.new([x, y], direction)
          carts[carts.length - 1].id = carts.length - 1
        else
          tracks[x][y] = char
        end
      end

      y += 1
    end
  end

  {tracks: tracks, carts: carts}
end

def get_track(tracks, coords)
  return '' if coords[0] < 0 || coords[0] > tracks.length || coords[1] < 0 || coords[1] > tracks[coords[0]].length

  tracks[coords[0]][coords[1]]
end

def coords_of_first_crash(tracks, carts)
  while true
    carts.each_with_index do |cart, i|
      cart.advance()

      carts.each_with_index do |cart2, i2|
        next if i == i2

        if cart.coords[0] == cart2.coords[0] && cart.coords[1] == cart2.coords[1]
          return cart.coords.join(',')
        end
      end

      track = get_track(tracks, cart.coords)

      if track == '+'
        cart.handle_intersection()
      elsif ['/', '\\'].include?(track)
        case track
          when '/'
            if cart.direction[0] > 0 || cart.direction[0] < 0
              cart.turn_left()
            else
              cart.turn_right()
            end
          when '\\'
            if cart.direction[0] > 0 || cart.direction[0] < 0
              cart.turn_right()
            else
              cart.turn_left()
            end
        end
      end
    end
  end
end

def last_cart_remaining_coords(tracks, carts)
  seconds = 1

  while true
    # Here's a fun thing: I skipped over this requirement in the original question, but AoC accepted my result sans-sorting as correct, even though
    # sorting them actually leads to a different crash location. Needless to say, this caused me quite a bit of frustration :P
    carts.sort_by! { |c| [c.coords[1], c.coords[0]] }

    carts.each_with_index do |cart, i|
      next if !cart.active

      cart.advance()

      carts.each_with_index do |cart2, i2|
        next if i == i2 || !cart2.active

        if cart.coords[0] == cart2.coords[0] && cart.coords[1] == cart2.coords[1]
          cart.active = cart2.active = false
          break
        end
      end

      track = get_track(tracks, cart.coords)

      if track == '+'
        cart.handle_intersection()
      elsif ['/', '\\'].include?(track)
        case track
          when '/'
            if cart.direction[0] > 0 || cart.direction[0] < 0
              cart.turn_left()
            else
              cart.turn_right()
            end
          when '\\'
            if cart.direction[0] > 0 || cart.direction[0] < 0
              cart.turn_right()
            else
              cart.turn_left()
            end
        end
      end
    end

    carts.keep_if { |cart| cart.active }

    break if carts.length == 1

    seconds += 1
  end

  carts[0].coords.join(',')
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_input = get_track_and_carts_from_file("day13_example.txt")
  puts(coords_of_first_crash(example_input[:tracks], example_input[:carts]))
  puts("INPUT SOLUTION:")
  file_input = get_track_and_carts_from_file("day13_input.txt")
  puts(coords_of_first_crash(file_input[:tracks], file_input[:carts]))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  example_input = get_track_and_carts_from_file("day13_example2.txt")
  puts(last_cart_remaining_coords(example_input[:tracks], example_input[:carts]))
  puts("INPUT SOLUTION:")
  file_input = get_track_and_carts_from_file("day13_input.txt")
  puts(last_cart_remaining_coords(file_input[:tracks], file_input[:carts]))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
