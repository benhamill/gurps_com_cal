require_relative 'attack'

module GurpsComCal
  class MeleeAttack < Attack
    def initialize weapon, name, damage, damage_type, skills, reach, parry_modifier, min_st=0
      super(weapon, name, damage, damage_type, skills, min_st)
      @reach = [reach].flatten
      @parry_modifier = parry_modifier
      @type = 'melee'
    end
  end
end
