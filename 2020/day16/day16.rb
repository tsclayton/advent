#!/usr/bin/env ruby

def get_lines_from_file(filename)
  File.read(filename).split("\n").reject {|s| s.empty? }
end

def get_ranges(lines)
  ranges = {}

  lines.each do |line|
    break if !line.match(/^your ticket/).nil?

    field = line.match(/[a-z ]+/).to_s
    numbers = line.scan(/[0-9]+/).map(&:to_i)

    ranges[field] = {min_1: numbers[0], max_1: numbers[1], min_2: numbers[2], max_2: numbers[3]}
  end

  ranges
end

def get_nearby_tickets(lines)
  nearby_tickets = []

  scanning_tickets = false
  lines.each do |line|
    if !line.match(/^nearby tickets:/).nil?
      scanning_tickets = true
      next
    end

    next if !scanning_tickets

    nearby_tickets << line.split(',').map(&:to_i)
  end

  nearby_tickets
end

def get_my_ticket(lines)
  i = lines.index('your ticket:')
  lines[i + 1].split(',').map(&:to_i)
end

def get_error_rate(nearby_tickets, ranges)
  invalid_numbers = []

  nearby_tickets.each do |ticket_numbers|
    invalid_number = nil

    ticket_numbers.each do |number|
      has_valid_range = false

      ranges.each do |field, range|
        has_valid_range = true if (number >= range[:min_1] && number <= range[:max_1]) || (number >= range[:min_2] && number <= range[:max_2])
        break if has_valid_range
      end

      if !has_valid_range
        invalid_number = number
        break
      end
    end

    invalid_numbers << invalid_number if invalid_number != nil
  end

  invalid_numbers.sum
end

def get_valid_tickets(nearby_tickets, ranges)
  valid_tickets = []

  nearby_tickets.each do |ticket_numbers|
    invalid_number = nil

    ticket_numbers.each do |number|
      has_valid_range = false

      ranges.each do |field, range|
        has_valid_range = true if (number >= range[:min_1] && number <= range[:max_1]) || (number >= range[:min_2] && number <= range[:max_2])
        break if has_valid_range
      end

      if !has_valid_range
        invalid_number = number
        break
      end
    end

    valid_tickets << ticket_numbers if invalid_number == nil
  end

  valid_tickets
end

def solve_ticket(my_ticket, nearby_tickets, ranges, field_exp)
  valid_tickets = get_valid_tickets(nearby_tickets, ranges) 
  valid_tickets << my_ticket

  field_map = {}

  for i in 0...my_ticket.length
    valid_fields = ranges.keys

    valid_tickets.each do |ticket_numbers|
      break if valid_fields.length == 1

      invalid_fields = []
      number = ticket_numbers[i]

      valid_fields.each do |field|
        range = ranges[field]
        if (number < range[:min_1] || number > range[:max_1]) && (number < range[:min_2] || number > range[:max_2])
          invalid_fields << field
        end
      end

      valid_fields -= invalid_fields
    end

    field_map[i] = valid_fields
  end

  invert_map = field_map.invert
  sorted_fields = field_map.values.sort_by {|f| f.length}
  trimmed_field_map = {}

  total_fields = []
  sorted_fields.each do |fields|
    trimmed_fields = fields - total_fields
    total_fields += trimmed_fields
    trimmed_field_map[invert_map[fields]] = trimmed_fields[0]
  end

  solution_product = 1

  trimmed_field_map.each do |i, field|
    next if field.match(field_exp).nil?
    solution_product *= my_ticket[i]
  end

  solution_product
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  document = [
    'class: 1-3 or 5-7',
    'row: 6-11 or 33-44',
    'seat: 13-40 or 45-50',
    'your ticket:',
    '7,1,14',
    'nearby tickets:',
    '7,3,47',
    '40,4,50',
    '55,2,20',
    '38,6,12'
  ]
  puts(get_error_rate(get_nearby_tickets(document), get_ranges(document)))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  document = get_lines_from_file('day16_input.txt')
  puts(get_error_rate(get_nearby_tickets(document), get_ranges(document)))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  document = [
    'class: 0-1 or 4-19',
    'row: 0-5 or 8-19',
    'seat: 0-13 or 16-19',
    'your ticket:',
    '11,12,13',
    'nearby tickets:',
    '3,9,18',
    '15,1,5',
    '5,14,9',
  ]
  puts(solve_ticket(get_my_ticket(document), get_nearby_tickets(document), get_ranges(document), /[a-z]+/))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  document = get_lines_from_file('day16_input.txt')
  puts(solve_ticket(get_my_ticket(document), get_nearby_tickets(document), get_ranges(document), /^departure/))
end

part_1_example()
part_1_final()
part_2_example()
part_2_final()