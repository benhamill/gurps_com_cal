require_relative '../spec_helper'

class TurnsHolder
  include GurpsComCal::Combat::Turns
end

describe "GurpsComCal::Combat::Turns" do
  subject { TurnsHolder.new }

  let(:the_flash) { GurpsComCal::Combatant.new(GurpsComCal::Character.new) }
  let(:a_cheetah) { GurpsComCal::Combatant.new(GurpsComCal::Character.new) }
  let(:some_schmoe) { GurpsComCal::Combatant.new(GurpsComCal::Character.new) }
  let(:combatants) { {
    'The Flash' => the_flash,
    'A Cheetah' => a_cheetah,
    'Some Schmoe' => some_schmoe,
  } }

  before(:each) do
    the_flash.basic_move = 20
    a_cheetah.basic_move = 10
    some_schmoe.basic_move = 5

    subject.stub(:combatants) { combatants.keys }
    subject.stub(:combatant) { |name| combatants[name] }
  end

  describe "#turn_order" do
    context "with combatants with different basic speeds" do
      it "should return in order of basic move" do
        subject.turn_order.should == ['The Flash', 'A Cheetah', 'Some Schmoe']
      end
    end

    context "with combatants with tied basic speeds but different DX" do
      before(:each) do
        [the_flash, a_cheetah, some_schmoe].each { |c| c.basic_move = 5 }
        the_flash.dx = 5
        a_cheetah.dx = 6
        some_schmoe.dx = 7
      end

      it "should return in order of DX" do
        subject.turn_order.should == ['Some Schmoe', 'A Cheetah', 'The Flash']
      end
    end

    context "with combatants all tied" do
      before(:each) do
        [the_flash, a_cheetah, some_schmoe].each { |c| c.basic_move = 5 }
      end

      it "should determine randomly" do
        subject.should_receive(:rand).exactly(3).times
        subject.turn_order
      end
    end
  end

  describe "#next_turn" do
    context "before combat has started" do
      it "should start combat with the first character in turn order" do
        pending
      end
    end
  end
end
