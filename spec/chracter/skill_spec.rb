require 'gurps_comcal/character/skills'

class SkillsHolder
  include GurpsComCal::Character::Skills
end

describe "GurpsComCal::Character::Skills" do
  subject { SkillsHolder.new }
end
