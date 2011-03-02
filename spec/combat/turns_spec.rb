require_relative '../spec_helper'

class TurnsHolder
  include GurpsComCal::Combat::Turns
end

describe "GurpsComCal::Combat::Turns" do
  subject { TurnsHolder.new }

  describe "#turn_order" do
    pending
  end
end
