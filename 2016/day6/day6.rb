#!/usr/bin/env ruby

def get_signal_from_file(filename)
  File.read(filename).split("\n")
end

def decode_signal(signal, modified_code = false)
  frequency = []

  signal.each do |message|
    for i in 0...message.length
      frequency[i] ||= {}
      frequency[i][message[i]] ||= 0
      frequency[i][message[i]] += 1
    end
  end

  if modified_code
    frequency.map { |signal_characters| signal_characters.invert[signal_characters.values.min] }.join('')
  else
    frequency.map { |signal_characters| signal_characters.invert[signal_characters.values.max] }.join('')
  end
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  signal = [
    'eedadn',
    'drvtee',
    'eandsr',
    'raavrd',
    'atevrs',
    'tsrnev',
    'sdttsa',
    'rasrtv',
    'nssdts',
    'ntnada',
    'svetve',
    'tesnvt',
    'vntsnd',
    'vrdear',
    'dvrsen',
    'enarar'
  ]
  puts(decode_signal(signal))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  signal = get_signal_from_file('day6_input.txt')
  puts(decode_signal(signal))
end

def part_2_example
  puts("PART 2 EXAMPLE SOLUTION:")
  signal = [
    'eedadn',
    'drvtee',
    'eandsr',
    'raavrd',
    'atevrs',
    'tsrnev',
    'sdttsa',
    'rasrtv',
    'nssdts',
    'ntnada',
    'svetve',
    'tesnvt',
    'vntsnd',
    'vrdear',
    'dvrsen',
    'enarar'
  ]
  puts(decode_signal(signal, true))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  signal = get_signal_from_file('day6_input.txt')
  puts(decode_signal(signal, true))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()