#!/usr/bin/env ruby

def is_real_room(room)
  char_count = {}

  split_room = room.split('-')
  for r in 0...(split_room.length - 1)
    for i in 0...split_room[r].length
      char = split_room[r][i]
      char_count[char] ||= 0
      char_count[char] += 1
    end
  end

  checksum = room.match(/\[[a-z]+\]/).to_s[1...-1]

  prev_char = checksum[0]
  prev_char_count = char_count[prev_char]

  sorted_char_count = char_count.to_a.sort_by {|x| [-x[1], x[0].ord]}

  sorted_char_count[0...5].map(&:first).join == checksum
end

def get_room_id(room)
  room.match(/[0-9]+/).to_s.to_i
end

def real_room_sum(rooms)
  sum = 0

  rooms.each do |room|
    sum += get_room_id(room) if is_real_room(room)
  end

  sum
end

def decrypt_room(room)
  real_name = ''

  room_id = get_room_id(room)

  for i in 0...room.length
    char = room[i]
    if char == '-'
      real_name << ' '
    elsif !char.match(/[0-9]/).nil?
      real_name.strip!
      break
    else
      rotated_char = (((char.ord - 'a'.ord + room_id) % 26) + 'a'.ord).chr
      real_name << rotated_char
    end
  end

  real_name
end

def get_northpole_storage_room_id(rooms)
  rooms.keep_if {|room| is_real_room(room)}

  rooms.each do |room|
    real_name = decrypt_room(room)
    return get_room_id(room) if real_name == 'northpole object storage'
  end

  0
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  input = [
    'aaaaa-bbb-z-y-x-123[abxyz]',
    'a-b-c-d-e-f-g-h-987[abcde]',
    'not-a-real-room-404[oarel]',
    'totally-real-room-200[decoy]'
  ]

  puts(real_room_sum(input))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  input = File.read('day4_input.txt').split("\n")
  puts(real_room_sum(input))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  puts(decrypt_room('qzmt-zixmtkozy-ivhz-343'))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  input = File.read('day4_input.txt').split("\n")
  puts(get_northpole_storage_room_id(input))
end

part_1_example()
part_1_final()
part_2_examples()
part_2_final()
