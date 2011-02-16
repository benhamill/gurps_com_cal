module GurpsComCal
  module Maneuver
    class Base
      attr_accessor :actor, :message, :options

      def initialize actor
        @actor = actor
        @next_method = :start
      end

      def next *args
        send(@next_method, *args)
      end
    end
  end
end
