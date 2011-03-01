module GurpsComCal
  class Combatant
    module Base
      module ClassMethods
        def load_yaml file_path
          self.new(Character.load_yaml(file_path))
        end
      end

      module InstanceMethods
        def initialize character
          @character = character
          @injury = 0
        end

        def method_missing method, *args, &block
          if pass_to_character? method
            @character.send(method, *args, &block)
          else
            super(method, *args, &block)
          end
        end

        def damage type, basic_damage
          injury = basic_damage * WOUNDING_MODS[type.to_s]
          @injury += injury.ceil
        end

        def current_hp
          @character.hp - @injury
        end

        private

        def pass_to_character? method
          @character.respond_to? method
        end

        WOUNDING_MODS = {
          'pi-' => 0.5,
          'burn' => 1.0,
          'cor' => 1.0,
          'cr' => 1.0,
          'fat' => 1.0,
          'pi' => 1.0,
          'tox' => 1.0,
          'cut' => 1.5,
          'pi+' => 1.5,
          'imp' => 2.0,
          'pi++' => 2.0
        }
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end
