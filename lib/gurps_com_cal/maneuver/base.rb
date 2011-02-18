module GurpsComCal
  module Maneuver
    class Base
      attr_accessor :actor, :message, :options

      def initialize actor
        @actor = actor
        @next_method = :start
      end

      def next *args
        @message, @options = nil, nil
        send(@next_method, *args)
        self
      end

      def done
        false
      end
    end
  end
end
