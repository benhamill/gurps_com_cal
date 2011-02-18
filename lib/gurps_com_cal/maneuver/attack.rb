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
        @next_method = :do_attack
        @message = "#{@actor.name}, roll against #{@attack.skill} and enter the result."
      end

      def do_attack result
        if result <= @attack.skill
          @defense = Defense.new(@target)
          @defense.next
          @message = "Success! #{@defense.message}"
          @options = @defense.options
        else
          @message = 'A miss! Maneuver ended.'
          @state = -1
        end
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
