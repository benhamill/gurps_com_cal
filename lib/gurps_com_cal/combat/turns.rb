module GurpsComCal
  class Combat
    module Turns
      def turn_order
        @turn_order ||= combatants.sort_by do |name|
          combatant = combatant(name)
          [-combatant.basic_speed, -combatant.dx, rand]
        end
      end

      def current_actor
        @current_actor
      end

      def next_turn
        @current_actor = turn_order.first

        say "It is #{current_actor}'s turn. Select a maneuver."

        maneuver_list.each_with_index do |maneuver, index|
          say "#{index + 1}. #{maneuver}"
        end

        index = ask "Selection:"
      end

      def maneuver_list
        GurpsComCal::Maneuver::LIST
      end
    end
  end
end
