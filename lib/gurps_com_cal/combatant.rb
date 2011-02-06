module GurpsComCal
  class Combatant
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
      @injury += injury
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
end
