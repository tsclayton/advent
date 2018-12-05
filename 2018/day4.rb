#!/usr/bin/env ruby

class Log
  attr_accessor :date
  attr_accessor :text
end

class GuardLog
  attr_accessor :guard_id
  attr_accessor :activity
  attr_accessor :date

  def initialize(guard_id, activity, date)
    @guard_id = guard_id
    @activity = activity
    @date = date
  end
end

def guard_logs_from_file(filename)
  guard_logs = []

  File.open(filename, "r") do |file|
    file.each_line do |line|
      split_line = line.split('] ')
      date_values = split_line[0].gsub(/\[/, '').gsub(/[-\s:]/, ',').split(',')
      date = Time.new(date_values[0], date_values[1], date_values[2], date_values[3], date_values[4])

      activity_line = split_line[1]
      # will have to fill in most of these ids later
      guard_id = 0
      activity = ''
      if activity_line.match(/Guard/) != nil
        guard_id = activity_line.match(/[0-9]+/).to_s.to_i
        activity = 'begin'
      elsif activity_line.match(/falls/) != nil
        activity = 'asleep'
      elsif activity_line.match(/wakes/) != nil
        activity = 'awake'
      end

      guard_logs << GuardLog.new(guard_id, activity, date)
    end
  end

  guard_logs
end

# sort by date and fill in missing guard ids
def sort_and_fill_guard_logs(guard_logs)
  guard_logs.sort_by!(&:date)
  current_guard_id = 0
  guard_logs.each do |guard_log|
    if guard_log.activity == 'begin'
      current_guard_id = guard_log.guard_id
    else
      guard_log.guard_id = current_guard_id
    end
  end
end

# {guard_id: => {minute => num_days_asleep}}}
def get_sleep_time_table(guard_logs)
  time_table = {}

  sleep_minute = 0
  guard_logs.each do |guard_log|
    time_table[guard_log.guard_id] ||= {}

    if guard_log.activity == "asleep"
      sleep_minute = guard_log.date.min
    elsif guard_log.activity == "awake"
      for min in sleep_minute...(guard_log.date.min)
        time_table[guard_log.guard_id][min] ||= 0
        time_table[guard_log.guard_id][min] += 1
      end
    end
  end

  time_table
end

def get_sleepiest_guard_product(guard_logs)
  sort_and_fill_guard_logs(guard_logs)
  time_table = get_sleep_time_table(guard_logs)

  sleepiest_guard_id = 0
  sleepiest_minute = 0
  max_minutes_asleep = 0

  time_table.each do |guard_id, sleep_mins|
    total_minutes_asleep = sleep_mins.values.reduce(0, :+)

    if total_minutes_asleep > max_minutes_asleep
      max_minutes_asleep = total_minutes_asleep
      sleepiest_guard_id = guard_id
      sleepiest_minute = sleep_mins.key(sleep_mins.values.max)
    end
  end

  sleepiest_guard_id * sleepiest_minute
end

def get_same_minute_sleeper_product(guard_logs)
  sort_and_fill_guard_logs(guard_logs)
  time_table = get_sleep_time_table(guard_logs)

  # wowzers, these variable names are garbage
  frequent_sleeper_guard_id = 0
  max_days_slept_on_minute = 0
  sleepiest_minute = 0

  time_table.each do |guard_id, sleep_mins|
    largest_day_count = (sleep_mins.values.max || 0)

    if largest_day_count > max_days_slept_on_minute
      max_days_slept_on_minute = largest_day_count
      frequent_sleeper_guard_id = guard_id
      sleepiest_minute = sleep_mins.key(max_days_slept_on_minute)
    end
  end

  frequent_sleeper_guard_id * sleepiest_minute
end

def part_1
  puts("EXAMPLE SOLUTIONS:")
  example_input = guard_logs_from_file('day_4_example.txt')
  puts(get_sleepiest_guard_product(example_input))
  puts("INPUT SOLUTION:")
  file_input = guard_logs_from_file("day4_input.txt")
  puts(get_sleepiest_guard_product(file_input))
end

def part_2
  puts("EXAMPLE SOLUTIONS:")
  example_input = guard_logs_from_file('day_4_example.txt')
  puts(get_same_minute_sleeper_product(example_input))
  puts("INPUT SOLUTION:")
  file_input = guard_logs_from_file("day4_input.txt")
  puts(get_same_minute_sleeper_product(file_input))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
