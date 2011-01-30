module GurpsComCal
  class Combatant
    def initialize character
      @character = character
    end

    def method_missing method, *args, &block
      if pass_to_character? method
        @character.send(method, *args, &block)
      else
        super(method, *args, &block)
      end
    end

    private

    def pass_to_character? method
      @character.respond_to? method
    end
  end
end
