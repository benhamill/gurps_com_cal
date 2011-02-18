module GurpsComCal
  module Maneuver
    class Attack < Base
      def start
        @next_method = :select_target
        @message = "#{@actor.name}, select a target."
      end

      private

      def select_target target
        @next_method = :select_weapon
        @target = target
        @message = "#{@actor.name}, select a weapon."
        @options = @actor.weapons
      end

      def select_weapon name
        @weapon = @actor.weapon(name)
        @next_method = :select_attack
        @message = "#{@actor.name}, select an attack."
        @options = @weapon.attacks
      end

      def select_attack name
        @attack = @weapon.attack(name)
        [:do_attack, "#{@actor.name} roll against #{@attack.skill} and enter the result.", nil]
      end

      def do_attack result
        if result <= @attack.skill
          [:select_defense, "Success! #{@target.name}, select a defense.", %w(parry dodge)]
        else
          false
        end
      end

      def select_defense name
        case name
        when 'dodge'
          @defense_target = @target.dodge
          [:do_defense, "#{@target.name}, roll against #{@defense_target} and enter the result.", nil]
        when 'parry'
          [:select_parry_weapon, "#{@target.name}, select a weapon to parry with.", @target.weapons]
        end
      end

      def select_parry_weapon name
        @parry_weapon = @target.weapon(name)
        [:select_parry_attack, "#{@target.name}, select an attack to parry with.", @parry_weapon.attacks]
      end

      def select_parry_attack name
        @parry_attack = @parry_weapon.attack name
        @defense_target = @parry_attack.parry
        [:do_defense, "#{@target.name}, roll against #{@defense_target} and enter the result.", nil]
      end

      def do_defense result
        if result <= @defense_target
          false
        else
          [:do_damage, "Hit! #{@actor.name}, roll #{@attack.damage.roll} for damage and enter the result.", nil]
        end
      end

      def do_damage result
        injury = @target.damage(@attack.damage.type, result)
        [nil, "#{@target.name} took #{injury} points of injury.", nil]
      end
    end
  end
end
