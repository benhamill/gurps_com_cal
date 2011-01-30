require_relative 'melee_attack'

module GurpsComCal
  class Weapon
    attr_reader :character, :name, :attacks

    def initialize character, name, weight=0
      @character = character
      @name = name
      @weight = weight
    end

    def attacks= attacks
      @attacks = {}

      [attacks].flatten.each do |attack|
        @attacks[attack.name] = attack
      end
    end

    def to_hash
      result = {}
      result['attacks'] = @attacks.inject([]) do |array, hash_member|
        array << hash_member[1].to_hash
        array
      end

      instance_variables.inject(result) do |result, variable|
        return result if variable == :@attacks

        stat_name = variable.to_s.gsub('@', '')
        result[stat_name] = instance_variable_get(variable)
        result
      end
    end

    def self.from_hash hash
      w = new hash['character'], hash['name'], hash['weight']
      attacks = hash['attacks'].collect { |attack_hash| Attack.from_hash({ 'weapon' => w }.merge(attack_hash)) }
      w.attacks = attacks
      w
    end
  end
end
