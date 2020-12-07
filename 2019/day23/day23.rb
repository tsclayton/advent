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

  def restart()
    @ip = 0
    @program = @program_copy.clone
    @pending_inputs = []
    @output = 0
    @relative_base = 0
  end

  def is_finished()
    @ip >= @program.length
  end

  def add_input(value)
    @pending_inputs << value
  end

  def add_ascii_input(ascii_input)
    inputs = ascii_input.split('').map(&:ord)
    inputs.each do |input|
      add_input(input)
    end
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

class Packet
  attr_accessor :destination
  attr_accessor :x
  attr_accessor :y

  def initialize(destination, x, y)
    @destination = destination
    @x = x
    @y = y
  end
end

class Computer
  attr_accessor :executor
  attr_accessor :address
  attr_accessor :packet_queue

  def initialize(executor, address)
    @executor = executor
    @address = address
    @packet_queue = []
    @executor.add_input(address)
  end

  def add_packet(packet)
    packet_queue << packet
  end

  def run()
    return nil if executor.is_finished

    if packet_queue.length == 0
      @executor.add_input(-1)
    else
      packet = packet_queue.shift()
      @executor.add_input(packet.x)
      @executor.add_input(packet.y)
    end

    output_address = @executor.run_program()
    output_x = @executor.run_program()
    output_y = @executor.run_program()

    return nil if output_address.nil? || output_x.nil? || output_y.nil?

    Packet.new(output_address, output_x, output_y)
  end
end

def run_network(program, nat_active)
  computers = []
  for i in 0...50
    executor = Executor.new(program, [])
    computers << Computer.new(executor, i)
  end

  last_nat_packet = nil
  previous_nat_sent_packet = nil

  while true
    idle_network = true

    computers.each do |computer|
      packet = computer.run()
      if !packet.nil?
        idle_network = false
        if packet.destination >= computers.length 
          if packet.destination == 255
            if nat_active
              last_nat_packet = packet
            else
              return packet.y
            end
          else
            puts "ERROR: Packet sent to invalid address #{packet.destination}"
          end
        else
          computers[packet.destination].add_packet(packet)
        end
      elsif computer.packet_queue.length > 0
        idle_network = false
      end
    end

    if nat_active && idle_network
      if !last_nat_packet.nil?
        computers[0].add_packet(last_nat_packet)
        if !previous_nat_sent_packet.nil? && previous_nat_sent_packet.y == last_nat_packet.y
          return last_nat_packet.y
        end
        previous_nat_sent_packet = last_nat_packet
      else
        puts "ERROR: NAT packet is nil and network is idle"
        return
      end
    end
  end
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  program = get_program_from_file("day23_input.txt")
  puts(run_network(program, false))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  program = get_program_from_file("day23_input.txt")
  puts(run_network(program, true))
end

part_1_final()
part_2_final()