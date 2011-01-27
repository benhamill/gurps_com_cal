module GurpsComCal
  class Character
    module Attributes
      attr_writer :st, :dx, :iq, :ht

      def st
        @st || 10
      end

      def dx
        @dx || 10
      end

      def iq
        @iq || 10
      end

      def ht
        @ht || 10
      end
    end
  end
end
