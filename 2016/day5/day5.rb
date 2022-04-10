#!/usr/bin/env ruby

require 'digest'

def get_password(door_id)
  password = ''
  i = 0

  while password.length < 8
    md5 = Digest::MD5.hexdigest(door_id + i.to_s)

    password += md5[5] if md5[0...5] == '00000'

    i += 1
  end

  password
end

def get_password_2(door_id)
  password = '________'
  progress = 0
  i = 0

  while progress < 8
    md5 = Digest::MD5.hexdigest(door_id + i.to_s)

    if md5[0...5] == '00000' && md5[5].to_i(16) < 8 && password[md5[5].to_i(16)] == '_'
      password[md5[5].to_i(16)] = md5[6]
      progress += 1
    end

    i += 1
  end

  password
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  puts(get_password('abc'))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  puts(get_password('ugkcyxxp'))
end

def part_2_example
  puts("PART 1 EXAMPLE SOLUTION:")
  puts(get_password_2('abc'))
end


def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  puts(get_password_2('ugkcyxxp'))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()
