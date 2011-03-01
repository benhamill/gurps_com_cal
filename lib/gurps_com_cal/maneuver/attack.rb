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
          @message = 'Success!'
          delegate_to_defense
        else
          @message = 'A miss! Attack failed.'
          @state = -1
        end
      end

      def delegate_to_defense *args
        @defense.next(*args)
        @message = @message ? "#{@message} #{@defense.message}" : @defense.message

        if @defense.continue?
          @options = @defense.options
          @next_method = :delegate_to_defense
        else
          finish_defense
        end
      end

      def finish_defense
        if @defense.success?
          @message = "#{@message} Attack failed."
          @state = -1
        else
          @next_method = :do_damage
          @message = "#{@message} #{@actor.name}, roll #{@attack.damage.roll} and enter the result."
        end
      end

      def do_damage result
        injury = @target.damage(@attack.damage.type, result)
        [nil, "#{@target.name} took #{injury} points of injury.", nil]
      end
    end
  end
end
