module GurpsComCal
  module Maneuver
    class Defense < Base
      def start
        @message = "#{@actor.name}, select a defense."
        @options = @actor.defenses
        @next_method = :select_defense
      end

      private

      def select_defense defense
        @message = 'Bloo'
      end
    end
  end
end
