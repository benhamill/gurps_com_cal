module GurpsComCal
  module Maneuver
    class Base
      attr_accessor :actor

      def initialize actor
        @actor = actor
        @next_method = :start
      end

      def next
        send(@next_method)
      end
    end
  end
end
