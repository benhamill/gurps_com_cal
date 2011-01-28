module GurpsComCal
  class Character
    module Attributes
      # Basic Attributes
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

      # Secondary Characteristics
      attr_writer :thrust, :swing, :bl, :hp, :will, :per, :fp, :basic_speed, :basic_move, :dodge

      def thrust
        @thrust || DAMAGE_TABLE[st][:thr]
      end

      def swing
        @swing || DAMAGE_TABLE[st][:sw]
      end

      def bl
        @bl || st * st / 5.0
      end

      def hp
        @hp || st
      end

      def will
        @will || iq
      end

      def per
        @per || iq
      end

      def fp
        @fp || ht
      end

      def basic_speed
        @basic_speed || (ht + dx) / 4.0
      end

      def basic_move
        @basic_move || basic_speed.to_i
      end

      def dodge
        @dodge || basic_speed.to_i + 3
      end

      DAMAGE_TABLE = {
        1   =>  {:thr => Roll.new('1d-6'), :sw => Roll.new('1d-5') },
        2   =>  {:thr => Roll.new('1d-6'), :sw => Roll.new('1d-5') },
        3   =>  {:thr => Roll.new('1d-5'), :sw => Roll.new('1d-4') },
        4   =>  {:thr => Roll.new('1d-5'), :sw => Roll.new('1d-4') },
        5   =>  {:thr => Roll.new('1d-4'), :sw => Roll.new('1d-3') },
        6   =>  {:thr => Roll.new('1d-4'), :sw => Roll.new('1d-3') },
        7   =>  {:thr => Roll.new('1d-3'), :sw => Roll.new('1d-2') },
        8   =>  {:thr => Roll.new('1d-3'), :sw => Roll.new('1d-2') },
        9   =>  {:thr => Roll.new('1d-2'), :sw => Roll.new('1d-1') },
        10  =>  {:thr => Roll.new('1d-2'), :sw => Roll.new('1d')   },
        11  =>  {:thr => Roll.new('1d-1'), :sw => Roll.new('1d+1') },
        12  =>  {:thr => Roll.new('1d-1'), :sw => Roll.new('1d+2') },
        13  =>  {:thr => Roll.new('1d')  , :sw => Roll.new('2d-1') },
        14  =>  {:thr => Roll.new('1d')  , :sw => Roll.new('2d')   },
        15  =>  {:thr => Roll.new('1d+1'), :sw => Roll.new('2d+1') },
        16  =>  {:thr => Roll.new('1d+1'), :sw => Roll.new('2d+2') },
        17  =>  {:thr => Roll.new('1d+2'), :sw => Roll.new('3d-1') },
        18  =>  {:thr => Roll.new('1d+2'), :sw => Roll.new('3d')   },
        19  =>  {:thr => Roll.new('2d-1'), :sw => Roll.new('3d+1') },
        20  =>  {:thr => Roll.new('2d-1'), :sw => Roll.new('3d+2') },
      }
    end
  end
end
