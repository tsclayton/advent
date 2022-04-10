#!/usr/bin/env ruby

def get_instructions_from_file(filename)
  File.read(filename).split("\n")
end

def process_instructions(instructions)
  starting_bot_id = 0
  bots = {}
  inputs = {}
  outputs = {}

  instructions.each do |instruction|
    if !instruction.match(/value/).nil?
      chip, bot_id = instruction.scan(/[0-9]+/).map(&:to_i)

      inputs[bot_id] ||= []
      inputs[bot_id] << chip

      if inputs[bot_id].length == 2
        starting_bot_id = bot_id
      end

    else
      types = instruction.scan(/(output|bot)/)[1...3].flatten
      bot_id, low_id, high_id = instruction.scan(/[0-9]+/).map(&:to_i)

      bots[bot_id] ||= {id: bot_id, low: nil, high: nil, is_output: false, chips: []}

      low = {}
      high = {}

      if types[0] == 'output'
        outputs[low_id] ||= {id: low_id, is_output: true, chips: []}
        low = outputs[low_id]
      else
        bots[low_id] ||= {id: low_id, low: 0, high: 0, is_output: false, chips: []}
        low = bots[low_id]
      end

      if types[1] == 'output'
        outputs[high_id] ||= {id: high_id, is_output: true, chips: []}
        high = outputs[high_id]
      else
        bots[high_id] ||= {id: high_id, low: 0, high: 0, is_output: false, chips: []}
        high = bots[high_id]
      end

      bots[bot_id][:low] = low
      bots[bot_id][:high] = high
    end
  end

  starting_bot = bots[starting_bot_id]

  {starting_bot: starting_bot, bots: bots, inputs: inputs, outputs: outputs}
end

def distribute(current_bot, inputs, outputs, low_compare = 0, high_compare = 0)
  return nil if current_bot[:is_output]

  if !inputs[current_bot[:id]].nil?
    current_bot[:chips] += inputs[current_bot[:id]]
    inputs[current_bot[:id]] = []
  end

  return nil if current_bot[:chips].length < 2

  low_chip, high_chip = current_bot[:chips].sort

  current_bot[:low][:chips] << low_chip
  current_bot[:high][:chips] << high_chip
  current_bot[:chips] = []

  low_result = distribute(current_bot[:low], inputs, outputs, low_compare, high_compare)
  high_result = distribute(current_bot[:high], inputs, outputs, low_compare, high_compare)

  return current_bot if low_chip == low_compare && high_chip == high_compare
  return low_result || high_result
end

def get_ouput_chips(instructions)
  result = process_instructions(instructions)
  distribute(result[:starting_bot], result[:inputs], result[:outputs])
  result[:outputs].sort.to_h.values.map {|o| o[:chips]}.flatten.inspect
end

def get_bot_by_comparison(instructions, low, high)
  result = process_instructions(instructions)
  comparison_bot = distribute(result[:starting_bot], result[:inputs], result[:outputs], low, high)
  comparison_bot[:id]
end

def get_output_product(instructions)
  result = process_instructions(instructions)
  distribute(result[:starting_bot], result[:inputs], result[:outputs])
  result[:outputs][0][:chips][0] * result[:outputs][1][:chips][0] * result[:outputs][2][:chips][0]
end

def part_1_example
  puts('PART 1 EXAMPLE SOLUTION:')
  instructions = [
    'value 5 goes to bot 2',
    'bot 2 gives low to bot 1 and high to bot 0',
    'value 3 goes to bot 1',
    'bot 1 gives low to output 1 and high to bot 0',
    'bot 0 gives low to output 2 and high to output 0',
    'value 2 goes to bot 2'
  ]

  puts(get_ouput_chips(instructions))
  puts(get_bot_by_comparison(instructions, 2, 5))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  instructions = get_instructions_from_file('day10_input.txt')
  puts(get_bot_by_comparison(instructions, 17, 61))
end

def part_2_final
  puts('PART 1 FINAL SOLUTION:')
  instructions = get_instructions_from_file('day10_input.txt')
  puts(get_output_product(instructions))
end

part_1_example()
part_1_final()
part_2_final()