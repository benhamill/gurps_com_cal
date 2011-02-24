module GurpsComCal
  class Combatant
    module Defense
      POSSIBLE_DEFENSES = %w{parry dodge}
      def defenses
        POSSIBLE_DEFENSES.collect do |defense_name|
          self.send("#{defense_name}?") ? defense_name : nil
        end.compact
      end

      private

      def dodge?
        true
      end

      def parry?
        equipped_weapon.respond_to(:parry)
      end
    end
  end
end
