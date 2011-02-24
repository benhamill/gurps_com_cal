require_relative 'combatant/base'
require_relative 'combatant/defense'
require_relative 'combatant/weapons'

module GurpsComCal
  class Combatant
    include Base
    include Defense
    include Weapons
  end
end
