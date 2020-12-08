#!/usr/bin/env ruby

def is_valid_password(password)
  contains_doubles = false

  for i in 1...(password.to_s.length)
    curr_digit = password.to_s[i].to_i
    prev_digit = password.to_s[i - 1].to_i

    if (i > 0 && curr_digit < prev_digit)
      return false
    end

    if (curr_digit == prev_digit)
      contains_doubles = true
    end
  end

  contains_doubles
end

def num_valid_passwords(lowerbound, upperbound)
  valid_passwords = 0

  for password in lowerbound..upperbound
    if is_valid_password(password)
      valid_passwords += 1
    end
  end

  valid_passwords
end

def is_valid_password_part_2(password)
  contains_doubles = false
  current_group = password.to_s[0].to_i
  curr_group_length = 1

  for i in 1...(password.to_s.length)
    curr_digit = password.to_s[i].to_i
    prev_digit = password.to_s[i - 1].to_i

    if (i > 0 && curr_digit < prev_digit)
      return false
    end

    if curr_digit == current_group
      curr_group_length += 1
    end

    if i == password.to_s.length - 1 || curr_digit != current_group
      if curr_group_length == 2
        contains_doubles = true
      end

      current_group = curr_digit
      curr_group_length = 1
    end
  end

  contains_doubles
end

def num_valid_passwords_part_2(lowerbound, upperbound)
  valid_passwords = 0

  for password in lowerbound..upperbound
    if is_valid_password_part_2(password)
      valid_passwords += 1
    end
  end

  valid_passwords
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  puts(is_valid_password(111111))
  puts(is_valid_password(223450))
  puts(is_valid_password(123789))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  puts(num_valid_passwords(128392, 643281))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  puts(is_valid_password_part_2(112233))
  puts(is_valid_password_part_2(123444))
  puts(is_valid_password_part_2(111122))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  puts(num_valid_passwords_part_2(128392, 643281))
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()
