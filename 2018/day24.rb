#!/usr/bin/env ruby

class Group
  attr_accessor :num_units
  attr_accessor :hp_per_unit
  attr_accessor :immunities
  attr_accessor :weaknesses
  attr_accessor :attack
  attr_accessor :attack_type
  attr_accessor :initiative
  attr_accessor :is_immune_system

  def initialize(num_units, hp_per_unit, immunities, weaknesses, attack, attack_type, initiative, is_immune_system)
    @num_units = num_units
    @hp_per_unit = hp_per_unit
    @immunities = immunities
    @weaknesses = weaknesses
    @attack = attack
    @attack_type = attack_type
    @initiative = initiative
    @is_immune_system = is_immune_system
  end

  def effective_power
    @num_units * @attack
  end

  def damage_received_from_enemy(enemy_group)
    damage_amount = enemy_group.effective_power()

    return 0 if @immunities.include?(enemy_group.attack_type)
    return damage_amount * 2 if @weaknesses.include?(enemy_group.attack_type)

    damage_amount
  end

  def take_damage_from_enemy(enemy_group)
    total_damage = damage_received_from_enemy(enemy_group)
    units_killed = (total_damage.to_f / @hp_per_unit.to_f).floor

    while total_damage > @hp_per_unit
      total_damage -= @hp_per_unit
      @num_units -= 1
    end
  end
end

class Unit
  attr_accessor :hp

  def initialize(hp)
    @hp = hp
  end

  def take_damage(damage)
    @hp = [@hp - damage, 0].max
  end
end

def run_combat(groups)
  while true
    groups.sort_by! { |group| [-group.effective_power() -group.initiative] }

    target_selection = {}

    groups.each do |group|
      maximum_damage_target = nil
      maximum_damage = 0
      groups.each do |target_group|
        next if target_group.is_immune_system == group.is_immune_system

        next if target_selection.values.include?(target_group)

        damage_amount = target_group.damage_received_from_enemy(group)

        if damage_amount >= maximum_damage && damage_amount > 0
          if maximum_damage_target.nil?
            maximum_damage_target = target_group
          elsif damage_amount == maximum_damage && maximum_damage_target.effective_power() == target_group.effective_power()
            maximum_damage_target = target_group if target_group.initiative > maximum_damage_target.initiative
          elsif damage_amount == maximum_damage
            maximum_damage_target = target_group if target_group.effective_power() > maximum_damage_target.effective_power()
          else
            maximum_damage_target = target_group
          end

          maximum_damage = damage_amount
        end
      end

      if !maximum_damage_target.nil?
        target_selection[group] = maximum_damage_target if !maximum_damage_target.nil?
      end
    end

    # Stalemate
    break if target_selection.empty?

    groups.sort_by! { |group| [-group.initiative] }

    groups.each do |attacking_group|
      defending_group = target_selection[attacking_group]
      next if defending_group.nil? || attacking_group.num_units == 0

      units_before = defending_group.num_units
      defending_group.take_damage_from_enemy(attacking_group)
    end

    groups.keep_if { |group| group.num_units > 0 }

    immune_groups_left = groups.select { |group| group.is_immune_system }.length

    break if immune_groups_left == 0 || immune_groups_left == groups.length
  end

  groups
end

def total_units_after_combat(groups)
  groups_remaining = run_combat(groups)

  total_units = 0

  groups_remaining.each do |group|
    total_units += group.num_units
  end

  total_units
end

def total_units_after_smallest_immune_boost(groups)
  total_boost = 0

  while true
    cloned_groups = []

    groups.each do |group|
      cloned_groups << group.clone
    end

    cloned_groups.each do |group|
      group.attack += total_boost if group.is_immune_system
    end

    run_combat(cloned_groups)
    if cloned_groups.select { |group| group.is_immune_system }.length == cloned_groups.length
      total_units = 0

      cloned_groups.each do |group|
        total_units += group.num_units
      end

      return total_units
    end

    total_boost += 1
  end
end

def part_1
  puts("EXAMPLE SOLUTION:")
  example_groups = [
    Group.new(17, 5390, [], ['radiation', 'bludgeoning'], 4507, 'fire', 2, true),
    Group.new(989, 1274, ['fire'], ['bludgeoning', 'slashing'], 25, 'slashing', 3, true),

    Group.new(801, 4706, [], ['radiation'], 116, 'bludgeoning', 1, false),
    Group.new(4485, 2961, ['radiation'], ['fire', 'cold'], 12, 'slashing', 4, false)
  ]
  puts(total_units_after_combat(example_groups))

  puts("INPUT SOLUTION:")
  input_groups = [
    Group.new(4592, 2061, ['slashing', 'radiation'], ['cold'], 4, 'fire', 9, true),
    Group.new(1383, 3687, [], [], 26, 'radiation', 15, true),
    Group.new(2736, 6429, ['slashing'], [], 20, 'slashing', 2, true),
    Group.new(777, 3708, ['radiation', 'cold'], ['slashing', 'fire'], 39, 'cold', 4, true),
    Group.new(6761, 2792, ['bludgeoning', 'fire', 'cold', 'slashing'], [], 3, 'radiation', 17, true),
    Group.new(6028, 5537, ['slashing'], [], 7, 'radiation', 6, true),
    Group.new(2412, 2787, [], [], 9, 'bludgeoning', 20, true),
    Group.new(6042, 7747, ['radiation'], [], 12, 'slashing', 12, true),
    Group.new(1734, 7697, [], ['radiation', 'cold'], 38, 'cold', 10, true),
    Group.new(4391, 3250, [], [], 7, 'cold', 19, true),

    Group.new(820, 46229, ['cold', 'bludgeoning'], [], 106, 'slashing', 18, false),
    Group.new(723, 30757, [], ['bludgeoning'], 80, 'fire', 3, false),
    Group.new(2907, 51667, ['bludgeoning'], ['slashing'], 32, 'fire', 1, false),
    Group.new(2755, 49292, [], ['bludgeoning'], 34, 'fire', 5, false),
    Group.new(5824, 24708, ['bludgeoning', 'cold', 'radiation', 'slashing'], [], 7, 'bludgeoning', 11, false),
    Group.new(7501, 6943, ['slashing'], ['cold'], 1, 'radiation', 8, false),
    Group.new(573, 10367, [], ['slashing', 'cold'], 30, 'radiation', 16, false),
    Group.new(84, 31020, [], ['cold'], 639, 'slashing', 14, false),
    Group.new(2063, 31223, ['bludgeoning'], ['radiation'], 25, 'cold', 13, false),
    Group.new(214, 31088, [], ['fire'], 271, 'slashing', 7, false)
  ]
  puts(total_units_after_combat(input_groups))
end

def part_2
  puts("EXAMPLE SOLUTION:")
  example_groups = [
    Group.new(17, 5390, [], ['radiation', 'bludgeoning'], 4507, 'fire', 2, true),
    Group.new(989, 1274, ['fire'], ['bludgeoning', 'slashing'], 25, 'slashing', 3, true),

    Group.new(801, 4706, [], ['radiation'], 116, 'bludgeoning', 1, false),
    Group.new(4485, 2961, ['radiation'], ['fire', 'cold'], 12, 'slashing', 4, false)
  ]
  puts(total_units_after_smallest_immune_boost(example_groups))

  puts("INPUT SOLUTION:")
  input_groups = [
    Group.new(4592, 2061, ['slashing', 'radiation'], ['cold'], 4, 'fire', 9, true),
    Group.new(1383, 3687, [], [], 26, 'radiation', 15, true),
    Group.new(2736, 6429, ['slashing'], [], 20, 'slashing', 2, true),
    Group.new(777, 3708, ['radiation', 'cold'], ['slashing', 'fire'], 39, 'cold', 4, true),
    Group.new(6761, 2792, ['bludgeoning', 'fire', 'cold', 'slashing'], [], 3, 'radiation', 17, true),
    Group.new(6028, 5537, ['slashing'], [], 7, 'radiation', 6, true),
    Group.new(2412, 2787, [], [], 9, 'bludgeoning', 20, true),
    Group.new(6042, 7747, ['radiation'], [], 12, 'slashing', 12, true),
    Group.new(1734, 7697, [], ['radiation', 'cold'], 38, 'cold', 10, true),
    Group.new(4391, 3250, [], [], 7, 'cold', 19, true),

    Group.new(820, 46229, ['cold', 'bludgeoning'], [], 106, 'slashing', 18, false),
    Group.new(723, 30757, [], ['bludgeoning'], 80, 'fire', 3, false),
    Group.new(2907, 51667, ['bludgeoning'], ['slashing'], 32, 'fire', 1, false),
    Group.new(2755, 49292, [], ['bludgeoning'], 34, 'fire', 5, false),
    Group.new(5824, 24708, ['bludgeoning', 'cold', 'radiation', 'slashing'], [], 7, 'bludgeoning', 11, false),
    Group.new(7501, 6943, ['slashing'], ['cold'], 1, 'radiation', 8, false),
    Group.new(573, 10367, [], ['slashing', 'cold'], 30, 'radiation', 16, false),
    Group.new(84, 31020, [], ['cold'], 639, 'slashing', 14, false),
    Group.new(2063, 31223, ['bludgeoning'], ['radiation'], 25, 'cold', 13, false),
    Group.new(214, 31088, [], ['fire'], 271, 'slashing', 7, false)
  ]
  puts(total_units_after_smallest_immune_boost(input_groups))
end

puts("PART 1 SOLUTIONS:")
part_1()
puts("PART 2 SOLUTIONS:")
part_2()
