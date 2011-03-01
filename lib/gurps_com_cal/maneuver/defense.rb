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
        @next_method = :do_dodge
        @message = "#{@actor.name}, roll against #{@actor.dodge} and enter the result."
      end

      def do_dodge result
        if result <= @actor.dodge
          @message = 'A success!'
          @state = 1
        else
          @message = 'A failure!'
          @state = -1
        end
      end
    end
  end
end
