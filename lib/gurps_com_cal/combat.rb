require_relative 'combat/combatants'
require_relative 'combat/turns'
require_relative 'combat/ui'

module GurpsComCal
  class Combat
    include Combatants
    include Turns
    include UI
  end
end
