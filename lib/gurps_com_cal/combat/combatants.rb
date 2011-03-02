module GurpsComCal
  class Combat
    module Combatants
      def load_combatant file_name
        combatant = Combatant.load_yaml(file_name)
      end

      def add_combatant combatant
        @combatants ||= {}
        @combatants[combatant.name] = combatant
      end

      def combatants
        @combatants.keys
      end

      def combatant name
        @combatants[name]
      end
    end
  end
end
