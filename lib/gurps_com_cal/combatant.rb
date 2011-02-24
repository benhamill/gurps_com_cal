require_relative 'combatant/base'
require_relative 'combatant/defense'

module GurpsComCal
  class Combatant
    include Base
    include Defense
  end
end
