#!/usr/bin/env ruby

def get_data_array_from_file(filename)
  File.open(filename, "r") do |file|
    file.each_line do |line|
      return line.gsub(/[\s+]+/, '').chars.map(&:to_i)
    end
  end
end

def get_layers(width, height, data)
  data.each_slice(width * height).to_a
end

def layer_with_fewest_zeros(width, height, data)
  layers = get_layers(width, height, data)
  best_layer = nil
  best_layer_zero_count = 0

  layers.each do |layer|
    zero_count = 0

    layer.each do |digit|
      zero_count += 1 if digit == 0
    end

    if best_layer.nil? || zero_count < best_layer_zero_count
      best_layer = layer
      best_layer_zero_count = zero_count
    end
  end

  best_layer
end

def part_1_calc(width, height, data)
  layer = layer_with_fewest_zeros(width, height, data)
  puts "#{layer}"
  one_count = two_count = 0

  layer.each do |digit|
    one_count += 1 if digit == 1
    two_count += 1 if digit == 2
  end

  one_count * two_count
end

def decode_image(width, height, data)
  layers = get_layers(width, height, data)
  combined_layer = []

  for i in 0...(height * width)
    final_pixel = 2

    layers.each do |layer|
      if (layer[i] == 0 || layer[i] == 1)
        final_pixel = layer[i]
        break
      end
    end

    combined_layer << final_pixel
  end

  row_string = ""
  for i in 0...combined_layer.length
    # use different characters to make it easier to read
    if combined_layer[i] == 0
      row_string << "`"
    elsif combined_layer[i] == 1
      row_string << "0"
    else
      row_string << " "
    end

    if (((i + 1) % (width)) == 0)
      puts row_string
      row_string = ""
    end
  end
end

def part_1_examples
  puts("PART 1 EXAMPLE SOLUTIONS:")
  puts(part_1_calc(3, 2, [1,2,3,4,5,6,7,8,9,0,1,2]))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  file_input = get_data_array_from_file("day8_input.txt")
  puts(part_1_calc(25, 6, file_input))
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  decode_image(2, 2, [0,2,2,2,1,1,2,2,2,2,1,2,0,0,0,0])
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  file_input = get_data_array_from_file("day8_input.txt")
  decode_image(25, 6, file_input)
end

part_1_examples()
part_1_final()
part_2_examples()
part_2_final()