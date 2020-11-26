#!/usr/bin/env ruby

def get_program_from_file(filename)
  File.open(filename, "r") do |file|
    file.each_line do |line|
      return line.gsub(/[\s+]+/, '').split(',').map(&:to_i)
    end
  end

  []
end

class Executor
  attr_accessor :program
  attr_accessor :ip
  attr_accessor :pending_inputs
  attr_accessor :output
  attr_accessor :relative_base

  def initialize(program, inputs)
    @program = program.clone
    @ip = 0
    @relative_base = 0
    @pending_inputs = inputs
  end

  def is_finished()
    @ip >= @program.length
  end

  def add_input(value)
    @pending_inputs << value
  end

  def get_value(value, mode)
    if mode == 0
      return read(value)
    elsif mode == 2
      return read(@relative_base + value)
    end
      
    return value
  end

  def get_address(address, mode)
    if mode == 2
      return @relative_base + address
    elsif mode == 1
      puts "invalid use of immediate mode"
    end
       
     address
  end

  def read(address)
    if address >= @program.length
      for i in @program.length...(address + 1)
        @program[i] = 0
      end
    end

    return @program[address]
  end

  def write(address, value)
    if address >= @program.length
      for i in @program.length...address
        @program[i] = 0
      end
    end

    @program[address] = value
  end

  def run_program()
    while @ip < @program.length
      instruction = @program[@ip]
      opcode = instruction % 100
      param_modes = [(instruction / 100) % 10, (instruction / 1000) % 10, (instruction / 10000) % 10]

      case opcode
      when 1
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])
        address = get_address(@program[@ip + 3], param_modes[2])
        write(address, param1 + param2)
        @ip = @ip + 4
      when 2
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])
        address = get_address(@program[@ip + 3], param_modes[2])
        write(address, param1 * param2)
        @ip = @ip + 4
      when 3
        if @pending_inputs.length == 0
          # Wait for input
          return nil
        else
          address = get_address(@program[@ip + 1], param_modes[0])
          write(address, @pending_inputs.shift)
          @ip = @ip + 2
        end
      when 4
        @output = get_value(@program[@ip + 1], param_modes[0])
        @ip = @ip + 2
        return @output
      when 5
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])

        if param1 != 0
          @ip = param2
        else
          @ip = @ip + 3
        end
      when 6
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])

        if param1 == 0
          @ip = param2
        else
          @ip = @ip + 3
        end
      when 7
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])
        address = get_address(@program[@ip + 3], param_modes[2])
        write(address, param1 < param2 ? 1 : 0)
        @ip = @ip + 4
      when 8
        param1 = get_value(@program[@ip + 1], param_modes[0])
        param2 = get_value(@program[@ip + 2], param_modes[1])
        address = get_address(@program[@ip + 3], param_modes[2])
        write(address, param1 == param2 ? 1 : 0)
        @ip = @ip + 4
      when 9
        @relative_base += get_value(@program[@ip + 1], param_modes[0])
        @ip = @ip + 2
      when 99
        # Halt by advancing @IP past @program length
        @ip = @program.length
      else
        puts("SOMETHING WENT WRONG! instruction = #{instruction}, @ip = #{@ip}")
        @ip = @program.length
      end
    end

    nil
  end
end

class Game
  attr_accessor :executor
  attr_accessor :grid
  attr_accessor :score
  attr_accessor :paddle_x
  attr_accessor :ball_x

  def initialize(executor)
    @executor = executor
    @grid = []
    @score = 0
    @paddle_x = nil
    @ball_x = nil
  end

  def get_num_blocks()
    num_blocks = 0

    @grid.each do |row|
      next if row.nil?

      row.each do |cell|
        num_blocks += 1 if cell == 2
      end

    end

    num_blocks
  end

  def draw_tile(tile, x, y)
    @grid[y] ||= []
    @grid[y][x] = tile
  end

  def draw_step()
    x = executor.run_program()
    y = executor.run_program()
    tile = executor.run_program()

    if !tile.nil? && !x.nil? && !y.nil?
      draw_tile(tile, x, y)
    end
  end

  def draw_screen()
    while !executor.is_finished
      draw_step()
    end
  end

  def game_step()
    x = executor.run_program()
    y = executor.run_program()
    tile = executor.run_program()

    if x.nil? || y.nil? || tile.nil?
      # Game awaiting input
      if !@paddle_x.nil? && !@ball_x.nil?
        if @paddle_x < @ball_x
          # Paddle is left of ball, move right
          executor.add_input(1)
        elsif @paddle_x > @ball_x
          # Paddle is right of ball, move left
          executor.add_input(-1)
        else
          executor.add_input(0)
        end
      else
        executor.add_input(0)
      end

      print_grid()
    elsif x == -1 && y == 0
      @score = tile
    else
      draw_tile(tile, x, y)
      if tile == 3
        @paddle_x = x
      elsif tile == 4
        @ball_x = x
      end
    end
  end

  def play_game()
    @executor.program[0] = 2
    while !executor.is_finished
      game_step()
    end
  end

  def get_tile_char(tile)
    case tile
    when 0
      ' '
    when 1
      '+'
    when 2
      '#'
    when 3
      '='
    when 4
      'o'
    end
  end

  def print_grid
    system "clear"

    puts "Score: #{@score}"
    for y in 0...@grid.length
      puts @grid[y].map{ |c| get_tile_char(c) }.join('')
    end
  end
end

def num_blocks(program)
  executor = Executor.new(program, [])
  game = Game.new(executor)
  game.draw_screen()
  game.print_grid()
  game.get_num_blocks()
end

def play_game(program)
  executor = Executor.new(program, [])
  game = Game.new(executor)
  game.play_game()
  game.score
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  file_input = get_program_from_file("day13_input.txt")
  puts(num_blocks(file_input))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  file_input = get_program_from_file("day13_input.txt")
  puts(play_game(file_input))
end

part_1_final()
part_2_final()