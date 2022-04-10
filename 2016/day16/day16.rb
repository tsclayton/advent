#!/usr/bin/env ruby

def dragon_curve(a)
  b = a.reverse

  for i in 0...b.length
    b[i] = (b[i] == '0' ? '1' : '0')
  end

  a + '0' + b
end

def get_checksum(data, disk_length)
  while data.length < disk_length
    data = dragon_curve(data)
  end

  data = data[0...disk_length]

  checksum = ''

  while true
    checksum = ''

    for i in 0...(data.length / 2)
      checksum << (data[i * 2] == data[(i * 2) + 1] ? '1' : '0')
    end

    break if checksum.length.odd?

    data = checksum
  end

  checksum
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  puts(get_checksum('10000', 20))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  puts(get_checksum('10001001100000001', 272))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  puts(get_checksum('10001001100000001', 35_651_584))
end

part_1_example()
part_1_final()
part_2_final()