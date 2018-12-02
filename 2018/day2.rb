#!/usr/bin/env ruby

def parse_file(filename)
  strings = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      strings << line.gsub(/\s+/, '')
    end
  end

  strings
end

def checksum(strings)
  two_count = 0
  three_count = 0

  strings.each do |string|
    letters = {}

    for i in 0...string.length
      char = string[i]
      letters[char] ||= 0
      letters[char] += 1
    end

    has_two = has_three = false
    letters.each do |key, val|

      has_two = true if val == 2
      has_three = true if val == 3
    end

    two_count += 1 if has_two
    three_count += 1 if has_three
  end

  two_count * three_count
end

def get_correct_common_chars(strings)
  correct_a = ''
  correct_b = ''

  for i in 0...(strings.length - 1)
    string_a = strings[i]
    for j in (i + 1)...strings.length
      string_b = strings[j]
      common_chars = ''

      for k in 0...string_a.length
        char = string_a[k]
        common_chars << char if string_a[k] == string_b[k]
      end

      puts "common chars: " + common_chars
      return common_chars if common_chars.length == (string_a.length - 1)
    end
  end

  ''
end

def part_1
  puts("EXAMPLE SOLUTIONS:")
  puts(checksum(['abcdef', 'bababc', 'abbcde', 'abcccd', 'aabcdd', 'abcdee', 'ababab']))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day2_input.txt")
  puts(checksum(file_input))
end

def part_2
  puts("EXAMPLE SOLUTIONS:")
  puts(get_correct_common_chars(['abcde', 'fghij', 'klmno', 'pqrst', 'fguij', 'axcye', 'wvxyz']))
  puts("INPUT SOLUTION:")
  file_input = parse_file("day2_input.txt")
  puts(get_correct_common_chars(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
