module GurpsComCal
  module Maneuver
    class Base
      attr_accessor :actor

      def initialize actor
        @actor = actor
      end
    end
  end
end
