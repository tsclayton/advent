#!/usr/bin/env ruby

def get_lines_from_file(filename)
  lines = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      lines << line.gsub(/\s+/, ' ').split(' ')
    end
  end

  lines
end

def no_duplicate_words(line)
  word_map = {}

  line.each do |word|
    if word_map[word] == true
      return false
    end

    word_map[word] = true
  end

  return true
end

def no_anagrams(line)
  word_map = {}

  line.each do |word|
    # Retrospect: much more efficient to compare alphabetically sorted strings
    permutations = word.split('').permutation.map(&:join)
    permutations.each do |perm|
      if word_map[perm] == true
        return false
      end
    end

    word_map[word] = true
  end

  return true
end

def num_valid_passphrases(input, validator)
  num_valid = 0

  input.each do |line|
    num_valid += 1 if validator.call(line)
  end

  return num_valid
end

def part_1
  puts("EXAMPLE SOLUTIONS:")
  puts(num_valid_passphrases([['aa', 'bb', 'cc', 'dd', 'ee']], method(:no_duplicate_words)))
  puts(num_valid_passphrases([['aa', 'bb', 'cc', 'dd', 'aa']], method(:no_duplicate_words)))
  puts(num_valid_passphrases([['aa', 'bb', 'cc', 'dd', 'aaa']], method(:no_duplicate_words)))
  puts("INPUT SOLUTION:")
  file_input = get_lines_from_file("day4_input.txt")
  puts(num_valid_passphrases(file_input, method(:no_duplicate_words)))
end


def part_2
  puts("EXAMPLE SOLUTIONS:")
  puts(num_valid_passphrases([['abcde', 'fghij']], method(:no_anagrams)))
  puts(num_valid_passphrases([['abcde', 'xyz', 'ecdab']], method(:no_anagrams)))
  puts(num_valid_passphrases([['a', 'ab', 'abc', 'abd', 'abf', 'abj']], method(:no_anagrams)))
  puts(num_valid_passphrases([['iiii', 'oiii', 'ooii', 'oooi', 'oooo']], method(:no_anagrams)))
  puts(num_valid_passphrases([['oiii', 'ioii', 'iioi', 'iiio']], method(:no_anagrams)))
  puts("INPUT SOLUTION:")
  file_input = get_lines_from_file("day4_input.txt")
  puts(num_valid_passphrases(file_input, method(:no_anagrams)))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
