module GurpsComCal
  class Attack
    attr_reader :name,  :damage, :damage_type, :skills, :min_st

    def initialize name, damage, damage_type, skills, min_st=0
      @name = name
      @damage = damage
      @damage_type = damage_type
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
  end
end
