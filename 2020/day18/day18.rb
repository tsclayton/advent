#!/usr/bin/env ruby

def get_expressions_from_file(filename)
  File.read(filename).split("\n")
end

class Expression
  attr_accessor :lhs
  attr_accessor :rhs
  attr_accessor :op

  def evaulate
    result = 0

    lhs_result = lhs.is_a?(Integer) ? lhs : lhs.evaulate()

    # Lazy way of dealing with expressions that were left open during parsing
    if rhs.nil? || op.nil?
      return lhs_result
    end

    rhs_result = rhs.is_a?(Integer) ? rhs : rhs.evaulate()

    case @op
    when '+'
      result = lhs_result + rhs_result
    when '*'
      result = lhs_result * rhs_result
    end

    result
  end

  def inspect
    lhs_result = lhs.is_a?(Integer) ? lhs : lhs.inspect()
    rhs_result = rhs.is_a?(Integer) ? rhs : rhs.inspect()

    "(#{lhs_result} #{op} #{rhs_result})"
  end
end

def peek(exp)
  return nil if exp.lstrip().empty?
  exp.lstrip()[0]
end

# removes the next non whitespace char from the expression
def pop_char(exp)
  exp.lstrip!()
  exp[0] = ''
end

# Fetches the next non whitespace char and removes it from the expression
def next_char(exp)
  exp.lstrip!()
  return nil if exp.empty?

  char = exp[0]
  exp[0] = ''
  char
end

def parse_expression(exp_str)
  exp = Expression.new()

  while exp_str.length > 0
    char = next_char(exp_str)
    return exp if char == ')'

    if !exp.rhs.nil?
      new_exp = Expression.new()
      new_exp.lhs = exp
      exp = new_exp
    end

    if exp.lhs.nil?
      exp.lhs = (char == '(' ? parse_expression(exp_str) : char.to_i)
    elsif exp.op.nil?
      exp.op = char
    elsif exp.rhs.nil?
      exp.rhs = (char == '(' ? parse_expression(exp_str) : char.to_i)
    end
  end

  exp
end

def parse_advanced_expression(exp_str)
  exp = Expression.new()
  # Separate RHS to build in order to respect precedence
  rhs_exp = nil

  while exp_str.length > 0
    char = peek(exp_str)
    if char == ')'
      pop_char(exp_str)
      break
    end

    if !exp.rhs.nil?
      new_exp = Expression.new()
      new_exp.lhs = exp
      exp = new_exp
    end

    if exp.lhs.nil?
      pop_char(exp_str)
      exp.lhs = (char == '(' ? parse_advanced_expression(exp_str) : char.to_i)
    elsif exp.op.nil?
      pop_char(exp_str)
      exp.op = char
      if exp.op == '*'
        rhs_exp = Expression.new()
      end
    elsif exp.rhs.nil?
      if rhs_exp.nil?
        pop_char(exp_str)
        exp.rhs = (char == '(' ? parse_advanced_expression(exp_str) : char.to_i)
      else
        if !rhs_exp.rhs.nil?
          new_rhs_exp = Expression.new()
          new_rhs_exp.lhs = rhs_exp
          rhs_exp = new_rhs_exp
        end

        if rhs_exp.lhs.nil?
          pop_char(exp_str)
          rhs_exp.lhs = (char == '(' ? parse_advanced_expression(exp_str) : char.to_i)
        elsif rhs_exp.op.nil?
          if char == '*'
            # don't pop only in this case so the next level in the tree can get its proper op
            exp.rhs = rhs_exp.lhs
            rhs_exp = nil
          else
            pop_char(exp_str)
            rhs_exp.op = '+'
          end
        elsif rhs_exp.rhs.nil?
          pop_char(exp_str)
          rhs_exp.rhs = (char == '(' ? parse_advanced_expression(exp_str) : char.to_i)
        end
      end
    end
  end

  if !rhs_exp.nil?
    exp.rhs = rhs_exp
  end

  exp
end

def evaluate_expression(exp_str)
  exp = parse_expression(exp_str)
  exp.evaulate()
end

def evaluate_advanced_expression(exp_str)
  exp = parse_advanced_expression(exp_str)
  exp.evaulate()
end

def expression_sum(expressions)
  expressions.map {|exp| evaluate_expression(exp)}.sum
end

def advanced_expression_sum(expressions)
  expressions.map {|exp| evaluate_advanced_expression(exp)}.sum
end

def part_1_examples
  puts('PART 1 EXAMPLE SOLUTIONS:')
  puts(evaluate_expression('1 + 2 * 3 + 4 * 5 + 6'))
  puts(evaluate_expression('1 + (2 * 3) + (4 * (5 + 6))'))
  puts(evaluate_expression('2 * 3 + (4 * 5)'))
  puts(evaluate_expression('5 + (8 * 3 + 9 + 3 * 4 * 3)'))
  puts(evaluate_expression('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))'))
  puts(evaluate_expression('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'))
end

def part_1_final
  puts('PART 1 FINAL SOLUTION:')
  expressions = get_expressions_from_file('day18_input.txt')
  puts(expression_sum(expressions))
end

def part_2_example
  puts('PART 2 EXAMPLE SOLUTION:')
  puts(evaluate_advanced_expression('1 + 2 * 3 + 4 * 5 + 6'))
  puts(evaluate_advanced_expression('1 + (2 * 3) + (4 * (5 + 6))'))
  puts(evaluate_advanced_expression('2 * 3 + (4 * 5)'))
  puts(evaluate_advanced_expression('5 + (8 * 3 + 9 + 3 * 4 * 3)'))
  puts(evaluate_advanced_expression('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))'))
  puts(evaluate_advanced_expression('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'))
end

def part_2_final
  puts('PART 2 FINAL SOLUTION:')
  expressions = get_expressions_from_file('day18_input.txt')
  puts(advanced_expression_sum(expressions))
end

part_1_examples()
part_1_final()
part_2_example()
part_2_final()
