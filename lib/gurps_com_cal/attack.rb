require_relative 'damage'

module GurpsComCal
  class Attack
    attr_reader :name, :damage, :damage_type, :skills, :min_st

    def initialize weapon, name, damage, skills, min_st=0
      @weapon = weapon
      @name = name
      @damage = Damage.new self, damage
      @skills = [skills].flatten
      @min_st = min_st
    end

    def to_hash
      instance_variables.inject({}) do |hash, variable|
        stat_name = variable.to_s.gsub(/@/, '')
        hash[stat_name] = instance_variable_get(variable)
        hash
      end
    end

    def character
      @weapon.character
    end

    def self.from_hash hash
      new(hash['weapon'], hash['name'], hash['damage'], hash['skills'], hash['min_st'])
    end
  end
end
