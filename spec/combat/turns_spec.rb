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
    the_flash.basic_speed = 20
    a_cheetah.basic_speed = 5.5
    some_schmoe.basic_speed = 5

    subject.stub(:combatants) { combatants.keys }
    subject.stub(:combatant) { |name| combatants[name] }
    subject.stub(:say)
    subject.stub(:ask)
  end

  describe "#turn_order" do
    context "with combatants with different basic speeds" do
      it "should return in order of basic speed" do
        subject.turn_order.should == ['The Flash', 'A Cheetah', 'Some Schmoe']
      end
    end

    context "with combatants with tied basic speeds but different DX" do
      before(:each) do
        [the_flash, a_cheetah, some_schmoe].each { |c| c.basic_speed = 5 }
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
        [the_flash, a_cheetah, some_schmoe].each { |c| c.basic_speed = 5 }
      end

      it "should determine randomly" do
        subject.should_receive(:rand).exactly(3).times
        subject.turn_order
      end
    end
  end

  describe "#next_turn" do
    before(:each) do
      GurpsComCal::Maneuver.stub(:maneuvers) { %w{Attack Wait} }
      GurpsComCal::Maneuver.stub(:maneuver).with('Attack') { GurpsComCal::Maneuver::Attack }
    end

    context "before combat has started" do
      it "should start combat with the first character in turn order" do
        subject.next_turn
        subject.current_actor.should == 'The Flash'
      end

      it "should ask to select an action" do
        subject.should_receive(:say).with("It is The Flash's turn. Select a maneuver.")
        subject.next_turn
      end

      it "should list all the actions for the user" do
        subject.should_receive(:say).with("1. Attack")
        subject.should_receive(:say).with("2. Wait")
        subject.next_turn
      end

      it "should expect input" do
        subject.should_receive(:ask).with("Selection:")
        subject.next_turn
      end

      context "when an action is selected" do
        before(:each) do
          subject.stub(:ask).with("Selection:") { "1" }
        end

        it "should create a new maneuver" do
          GurpsComCal::Maneuver::Attack.should_receive(:new).with(the_flash)
          subject.next_turn
        end
      end
    end
  end
end
