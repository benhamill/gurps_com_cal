module GurpsComCal
  module Maneuver
    class Base
      attr_accessor :actor, :message, :options

      def initialize actor
        @actor = actor
        @next_method = :start
        @state = 0
      end

      def next *args
        @message, @options = nil, nil
        send(@next_method, *args)
        self
      end

      def done
        false
      end

      def continue?
        @state == 0
      end

      def fail?
        @state < 0
      end

      def success?
        @state > 0
      end
    end
  end
end
