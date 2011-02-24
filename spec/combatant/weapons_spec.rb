require_relative '../spec_helper'

class WeaponsHolder
  include GurpsComCal::Combatant::Weapons
end

describe "GurpsComCal::Combatant::Weapons" do
  subject { WeaponsHolder.new }

  pending
end
