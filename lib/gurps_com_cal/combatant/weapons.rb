module GurpsComCal
  class Combatant
    module Weapons
      attr_reader :equipped_weapon

      def equip_weapon weapon
        if weapon.is_a? String
          @equipped_weapon = @character.weapon(weapon)
        else
          @equipped_weapon = @character.weapon(weapon.name)
        end

        self
      end
    end
  end
end
