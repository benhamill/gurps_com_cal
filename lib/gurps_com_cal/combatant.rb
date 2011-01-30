module GurpsComCal
  class Combatant
    def initialize character
      @character = character
    end

    def method_missing method, *args, &block
      @character.send(method, *args, &block)
    end
  end
end
