require_relative '../spec_helper'

class WeaponsHolder
  include GurpsComCal::Character::Weapons
end

describe "GurpsComCal::Character::Weapons" do
  subject { WeaponsHolder.new }
end
