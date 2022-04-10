#!/usr/bin/env ruby

def get_ip_addresses_from_file(filename)
  File.read(filename).split("\n")
end

def is_abba(sequence)
  sequence[0] == sequence[3] && sequence[0] != sequence[1] && sequence[1] == sequence[2]
end

def get_tls_ips(ip_addresses)
  tls_ips = []

  ip_addresses.each do |ip_address|
    no_hypernet_abba = true
    hypernet_sequence = false
    sequence = ip_address[0...4]
    contains_abba = is_abba(sequence)

    for i in 4...ip_address.length
      sequence = sequence[1...4] + ip_address[i]

      hypernet_sequence = true if ip_address[i] == '['
      hypernet_sequence = false if ip_address[i] == ']'

      if is_abba(sequence)
        if hypernet_sequence
          no_hypernet_abba = false
          break
        else
          contains_abba = true
        end
      end
    end

    tls_ips << ip_address if contains_abba && no_hypernet_abba
  end

  tls_ips
end

def is_aba(sequence)
  sequence[0] == sequence[2] && sequence[0] != sequence[1]
end

def is_ssl(abas, babs)
  babs.each do |bab|
    abas.each do |aba|
      return true if bab[0] == aba[1] && bab[1] == aba[0]
    end
  end

  false
end

def get_ssl_ips(ip_addresses)
  ssl_ips = []

  ip_addresses.each do |ip_address|
    hypernet_sequence = false
    sequence = ip_address[0...3]
    abas = []
    babs = []
    abas << sequence if is_aba(sequence)

    for i in 3...ip_address.length
      sequence = sequence[1...3] + ip_address[i]

      hypernet_sequence = true if ip_address[i] == '['
      hypernet_sequence = false if ip_address[i] == ']'

      if is_aba(sequence)
        if hypernet_sequence
          babs << sequence
        else
          abas << sequence
        end
      end
    end

    ssl_ips << ip_address if is_ssl(abas, babs)
  end

  ssl_ips
end

def part_1_example
  puts("PART 1 EXAMPLE SOLUTION:")
  ip_addresses = [
    'abba[mnop]qrst',
    'abcd[bddb]xyyx',
    'aaaa[qwer]tyui',
    'ioxxoj[asdfgh]zxcvbn',
  ]

  puts(get_tls_ips(ip_addresses))
end

def part_1_final
  puts("PART 1 FINAL SOLUTION:")
  ip_addresses = get_ip_addresses_from_file('day7_input.txt')
  puts(get_tls_ips(ip_addresses).length)
end

def part_2_examples
  puts("PART 2 EXAMPLE SOLUTIONS:")
  ip_addresses = [
    'aba[bab]xyz',
    'xyx[xyx]xyx',
    'aaa[kek]eke',
    'zazbz[bzb]cdb',
  ]
  puts(get_ssl_ips(ip_addresses))
end

def part_2_final
  puts("PART 2 FINAL SOLUTION:")
  ip_addresses = get_ip_addresses_from_file('day7_input.txt')
  puts(get_ssl_ips(ip_addresses).length)
end

part_1_example()
part_1_final()
part_2_examples()
part_2_final()