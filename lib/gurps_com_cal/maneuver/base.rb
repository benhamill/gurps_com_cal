module GurpsComCal
  module Maneuver
    class Base
      attr_accessor :actor

      def initialize actor
        @actor = actor
      end

      def next
        start
      end
    end
  end
end
