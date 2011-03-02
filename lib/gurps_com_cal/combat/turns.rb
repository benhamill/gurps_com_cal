module GurpsComCal
  class Combat
    module Turns
      def turn_order
        @turn_order ||= combatants.sort do |one, other|
          -1 * combatant(one).basic_move <=> combatant(other).basic_move
        end
      end
    end
  end
end
