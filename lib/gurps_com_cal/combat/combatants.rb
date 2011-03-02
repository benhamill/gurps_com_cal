module GurpsComCal
  class Combat
    module Combatants
      def initialize
        @combatants = {}
        super
      end

      def load_combatant file_name, opts = {}
        combatant = Combatant.load_yaml(file_name)
        combatant.name = opts[:as] if opts[:as]
        add_combatant combatant
      end

      def add_combatant combatant
        @combatants[combatant.name] = combatant
      end

      def combatants
        @combatants.keys
      end

      def combatant name
        @combatants[name]
      end

      def mook file_name, count, name='mook'
        count.times do |n|
          load_combatant file_name, :as => "#{name}_#{n+1}"
        end
      end
    end
  end
end
