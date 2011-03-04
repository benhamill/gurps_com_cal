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
        if @turn_number
          @current_actor = turn_order[(@turn_number - 1) % turn_order.length]
        else
          @current_actor = turn_order.first
        end

        @current_actor
      end

      def turn
        @turn_number ||= 0
        @turn_number += 1

        say "It is #{current_actor}'s turn. Select a maneuver."

        maneuver_name = menu GurpsComCal::Maneuver.maneuvers
        maneuver_class = GurpsComCal::Maneuver.maneuver(maneuver_name)
        maneuver = maneuver_class.new(combatant(current_actor))

        while maneuver.continue? do
          say maneuver.message

          if maneuver.options
            input = menu maneuver.options
          else
            input = ask "Result:"
          end
        end
      end
    end
  end
end
