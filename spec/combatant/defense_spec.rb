require_relative '../spec_helper'

class DefenseHolder
  include GurpsComCal::Combatant::Defense
end

describe "GurpsComCal::Combatant::Defense" do
  subject { DefenseHolder.new }

  pending
end
