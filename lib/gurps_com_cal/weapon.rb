require_relative 'weapon/melee_attack'

module GurpsComCal
  class Weapon
    attr_reader :character, :name

    def initialize character, name, weight=0
      @character = character
      @name = name
      @weight = weight
    end

    def inspect
      instance_vars = instance_variables.collect do |var|
        next if var == :@character
        "#{var.to_s}=#{instance_variable_get(var).inspect}"
      end.compact.join(' ')

      "#<#{self.class} #{instance_vars}>"
    end

    def attacks= attacks
      @attacks = {}

      [attacks].flatten.each do |attack|
        @attacks[attack.name] = attack
      end
    end

    def attacks
      @attacks.keys
    end

    def attack attack_name
      @attacks[attack_name]
    end

    def to_hash
      result = {}
      result['attacks'] = @attacks.inject([]) do |array, hash_member|
        array << hash_member[1].to_hash
        array
      end

      instance_variables.inject(result) do |result, variable|
        unless variable == :@character or variable == :@attacks
          stat_name = variable.to_s.gsub('@', '')
          result[stat_name] = instance_variable_get(variable)
        end

        result
      end
    end

    def self.from_hash hash
      w = new hash['character'], hash['name'], hash['weight']

      attacks = hash['attacks'].collect do |attack_hash|
        if attack_hash['type'] == 'melee'
          MeleeAttack.from_hash({ 'weapon' => w }.merge(attack_hash))
        else
          Attack.from_hash({ 'weapon' => w }.merge(attack_hash))
        end
      end

      w.attacks = attacks
      w
    end
  end
end
