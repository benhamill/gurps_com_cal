module GurpsComCal
  class Combatant
    module Weapons
      attr_reader :equipped_weapon

      def equip_weapon weapon
        if @character.weapon(weapon.name) == weapon
          @equipped_weapon = @character.weapon(weapon.name)
        end

        self
      end
    end
  end
end
