#!/usr/bin/env ruby

def get_passports_from_file(filename)
  passports = []
  current_passport = {}

  File.open(filename, "r") do |file|
    file.each_line do |line|
      if line.length > 1
        kv_pair_strs = line.split(' ')
        kv_pair_strs.each do |kv_pair_str|
          kv_pair = kv_pair_str.split(':')
          current_passport[kv_pair[0]] = kv_pair[1]
        end
      else
        # newline
        passports << current_passport
        current_passport = {}
      end
    end
  end

  passports << current_passport if !current_passport.empty?
  passports
end

def num_passports_with_all_required_fields(passports)
  valid_passports = 0

  required_fields = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']

  passports.each do |passport|
    valid_passport = true

    required_fields.each do |required_field|
      if passport[required_field].nil?
        valid_passport = false
        break
      end
    end

    valid_passports += 1 if valid_passport
  end

  valid_passports
end

def num_valid_passports(passports)
  valid_passports = 0

  passports.each do |passport|
    valid_passport = true

    valid_passport = false if passport['byr'].nil? || passport['byr'].length != 4 || passport['byr'].to_i < 1920 || passport['byr'].to_i > 2002
    valid_passport = false if passport['iyr'].nil? || passport['iyr'].length != 4 || passport['iyr'].to_i < 2010 || passport['iyr'].to_i > 2020
    valid_passport = false if passport['eyr'].nil? || passport['eyr'].length != 4 || passport['eyr'].to_i < 2020 || passport['eyr'].to_i > 2030

    if !passport['hgt'].nil? && !passport['hgt'].match(/^[0-9]+(cm|in)$/).nil?
      unit = passport['hgt'].match(/(cm|in)$/).to_s
      height = passport['hgt'].match(/[0-9]+/).to_s.to_i
      if unit == 'cm'
        valid_passport = false if height < 150 || height > 193
      else
        valid_passport = false if height < 59 || height > 76
      end
    else
      valid_passport = false
    end

    valid_passport = false if passport['hcl'].nil? || passport['hcl'].match(/^#[a-f0-9]{6}$/).nil?
    valid_passport = false if passport['ecl'].nil? || !['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].member?(passport['ecl'])
    valid_passport = false if passport['pid'].nil? || passport['pid'].match(/^[0-9]{9}$/).nil?

    valid_passports += 1 if valid_passport
  end

  valid_passports
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  puts(num_passports_with_all_required_fields([
    {'ecl' => 'gry', 'pid' => '860033327', 'eyr' => '2020', 'hcl' => '#fffffd', 'byr' => '1937', 'iyr' => '2017', 'cid' => '147', 'hgt' => '183cm'},
    {'iyr' => '2013', 'ecl' => 'amb', 'cid' => '350', 'eyr' => '2023', 'pid' => '028048884', 'hcl' => '#cfa07d', 'byr' => '1929'},
    {'hcl' => '#ae17e1', 'iyr' => '2013', 'eyr' => '2024', 'ecl' => 'brn', 'pid' => '760753108', 'byr' => '1931', 'hgt' => '179cm'},
    {'hcl' => '#cfa07d', 'eyr' => '2025', 'pid' => '166559648', 'iyr' => '2011', 'ecl' => 'brn', 'hgt' => '59in'}
  ]))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  passports = get_passports_from_file("day4_input.txt")
  puts(num_passports_with_all_required_fields(passports))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  invalid_passports = [
    {'eyr' => '1972', 'cid' => '100', 'hcl' => '#18171d', 'ecl' => 'amb', 'hgt' => '170', 'pid' => '186cm', 'iyr' => '2018', 'byr' => '1926'},
    {'iyr' => '2019', 'hcl' => '#602927', 'eyr' => '1967', 'hgt' => '170cm', 'ecl' => 'grn', 'pid' => '012533040', 'byr' => '1946'},
    {'hcl' => 'dab227', 'iyr' => '2012', 'ecl' => 'brn', 'hgt' => '182cm', 'pid' => '021572410', 'eyr' => '2020', 'byr' => '1992', 'cid' => '277'},
    {'hgt' => '59cm', 'ecl' => 'zzz', 'eyr' => '2038', 'hcl' => '74454a', 'iyr' => '2023', 'pid' => '3556412378', 'byr' => '2007'}
  ]
  puts(num_valid_passports(invalid_passports))

  valid_passports = [
    {'pid' => '087499704', 'hgt' => '74in', 'ecl' => 'grn', 'iyr' => '2012', 'eyr' => '2030', 'byr' => '1980', 'hcl' => '#623a2f'},
    {'eyr' => '2029', 'ecl' => 'blu', 'cid' => '129', 'byr' => '1989', 'iyr' => '2014', 'pid' => '896056539', 'hcl' => '#a97842', 'hgt' => '165cm'},
    {'hcl' => '#888785', 'hgt' => '164cm', 'byr' => '2001', 'iyr' => '2015', 'cid' => '88', 'pid' => '545766238', 'ecl' => 'hzl', 'eyr' => '2022'},
    {'iyr' => '2010', 'hgt' => '158cm', 'hcl' => '#b6652a', 'ecl' => 'blu', 'byr' => '1944', 'eyr' => '2021', 'pid' => '093154719'}
  ]
  puts(num_valid_passports(valid_passports))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  passports = get_passports_from_file("day4_input.txt")
  puts(num_valid_passports(passports))
end

part_1_example()
part_1_final()
part_2_examples()
part_2_final()
