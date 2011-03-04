module GurpsComCal
  class Combat
    module Turns
      def turn_order
        @turn_order ||= combatants.sort_by do |name|
          combatant = combatant(name)
          [-combatant.basic_move, -combatant.dx, rand]
        end
      end

      def current_actor
        @current_actor
      end
    end
  end
end
