require_relative '../spec_helper'

class TurnsHolder
  include GurpsComCal::Combat::Turns
end

describe "GurpsComCal::Combat::Turns" do
  subject { TurnsHolder.new }

  describe "#turn_order" do
    let(:the_flash) { GurpsComCal::Combatant.new(GurpsComCal::Character.new) }
    let(:a_cheetah) { GurpsComCal::Combatant.new(GurpsComCal::Character.new) }
    let(:some_schmoe) { GurpsComCal::Combatant.new(GurpsComCal::Character.new) }
    let(:combatants) { {
      'The Flash' => the_flash,
      'A Cheetah' => a_cheetah,
      'Some Schmoe' => some_schmoe,
    } }

    before(:each) do
      subject.stub(:combatants) { combatants.keys }
      subject.stub(:combatant) { |name| combatants[name] }
    end

    context "with combatants with different basic speeds" do
      before(:each) do
        the_flash.basic_move = 20
        a_cheetah.basic_move = 10
        some_schmoe.basic_move = 5
      end

      it "should return in order of basic move" do
        subject.turn_order.should == ['The Flash', 'A Cheetah', 'Some Schmoe']
      end
    end
  end
end
