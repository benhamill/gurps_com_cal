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
        self.send("selected_#{defense}")
      end

      def selected_dodge
        @message = "#{@actor.name}, roll against #{@actor.dodge} and enter the result."
      end
    end
  end
end
