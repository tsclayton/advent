#!/usr/bin/env ruby

require 'digest'

def stretched_hash(salt, i)
  md5 = Digest::MD5.hexdigest(salt + i.to_s)

  for j in 0...2016
    md5 = Digest::MD5.hexdigest(md5)
  end

  md5
end

def otp_index(salt, key_stretching = false)
  i = 0
  keys = []
  potentials = {}

  # Get more keys than needed and sort later as the way we iterate can jumble up the key order
  while keys.length < 100
    md5 = key_stretching ? stretched_hash(salt, i) : Digest::MD5.hexdigest(salt + i.to_s)

    char_run = ''
    triple_found = false
    for c in 0...md5.length
      char = md5[c]

      if char_run[0] != char
        char_run = char
      else
        char_run += char
      end

      if char_run.length == 3 && !triple_found
        potentials[char] ||= []
        potentials[char] << {key: md5, i: i}
        triple_found = true
      end

      if char_run.length == 5 && !potentials[char].nil?
        new_potentials = []

        potentials[char].each do |potential|
          if i > potential[:i] && i - potential[:i] <= 1000
            keys << potential
          elsif i - potential[:i] <= 1000
            # filter out selected keys and keys that are over 1000 indexes old
            new_potentials << potential
          end
        end

        potentials[char] = new_potentials
      end
    end

    i += 1
  end

  keys.sort_by {|key| key[:i]}[63][:i]
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  puts(otp_index('abc'))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  puts(otp_index('qzyelonm'))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  puts(stretched_hash('abc', 0))
  puts(otp_index('abc', true))
end

#20316 too low
def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  puts(otp_index('qzyelonm', true))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()