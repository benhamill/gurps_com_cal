require_relative 'attack'

module GurpsComCal
  class Weapon
    class MeleeAttack < Attack
      def initialize weapon, name, damage, skills, reach, parry_modifier, min_st=0
        super(weapon, name, damage, skills, min_st)
        @reach = [reach].flatten
        @parry_modifier = parry_modifier
        @type = 'melee'
      end

      def self.from_hash hash
        new(hash['weapon'], hash['name'], hash['damage'], hash['skills'], hash['reach'], hash['parry_modifier'], hash['min_st'].to_i)
      end

      def parry
        skill + @parry_modifier
      end
    end
  end
end
