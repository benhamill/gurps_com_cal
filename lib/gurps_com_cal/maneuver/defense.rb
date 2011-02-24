module GurpsComCal
  module Maneuver
    class Defense < Base
      def start
        @message = "#{@actor.name}, select a defense."
        @options = @actor.defenses
      end
    end
  end
end
