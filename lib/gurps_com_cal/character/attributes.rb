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
        1   =>  {:thr => '1d-6' , :sw => '1d-5' },
        2   =>  {:thr => '1d-6' , :sw => '1d-5' },
        3   =>  {:thr => '1d-5' , :sw => '1d-4' },
        4   =>  {:thr => '1d-5' , :sw => '1d-4' },
        5   =>  {:thr => '1d-4' , :sw => '1d-3' },
        6   =>  {:thr => '1d-4' , :sw => '1d-3' },
        7   =>  {:thr => '1d-3' , :sw => '1d-2' },
        8   =>  {:thr => '1d-3' , :sw => '1d-2' },
        9   =>  {:thr => '1d-2' , :sw => '1d-1' },
        10  =>  {:thr => '1d-2' , :sw => '1d'   },
        11  =>  {:thr => '1d-1' , :sw => '1d+1' },
        12  =>  {:thr => '1d-1' , :sw => '1d+2' },
        13  =>  {:thr => '1d'   , :sw => '2d-1' },
        14  =>  {:thr => '1d'   , :sw => '2d'   },
        15  =>  {:thr => '1d+1' , :sw => '2d+1' },
        16  =>  {:thr => '1d+1' , :sw => '2d+2' },
        17  =>  {:thr => '1d+2' , :sw => '3d-1' },
        18  =>  {:thr => '1d+2' , :sw => '3d'   },
        19  =>  {:thr => '2d-1' , :sw => '3d+1' },
        20  =>  {:thr => '2d-1' , :sw => '3d+2' },
      }
    end
  end
end
