require_relative 'combat/combatants'
require_relative 'combat/turns'

module GurpsComCal
  class Combat
    include Combatants
    include Turns
  end
end
