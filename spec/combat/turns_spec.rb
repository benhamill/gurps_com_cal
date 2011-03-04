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
    subject.stub(:menu)
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

  describe "#current_actor" do
    context "before combat has started" do
      it "should start with the first character in turn order" do
        subject.current_actor.should == 'The Flash'
      end
    end

    context "on the 3rd turn" do
      before(:each) do
        subject.instance_variable_set(:@turn_number, 3)
      end

      it "should be the third combatant" do
        subject.current_actor.should == 'Some Schmoe'
      end
    end

    context "on the 5th turn" do
      before(:each) do
        subject.instance_variable_set(:@turn_number, 5)
      end

      it "should be the second combatant" do
        subject.current_actor.should == 'A Cheetah'
      end
    end
  end

  describe "#turn" do
    let(:attack_maneuver) { double(GurpsComCal::Maneuver::Attack, :continue? => false, :start => true, :message => 'done nao') }
    let(:attack) { double('ATTACK', :new => attack_maneuver) }
    let(:wait) { double('WAIT') }

    before(:each) do
      GurpsComCal::Maneuver.stub(:maneuvers) { %w{Attack Wait} }
      GurpsComCal::Maneuver.stub(:maneuver).with('Attack') { attack }
      GurpsComCal::Maneuver.stub(:maneuver).with('Wait') { wait }

      subject.stub(:current_actor) { 'The Flash' }
      subject.stub(:menu).with(%w{Attack Wait}) { "Attack" }
    end

    it "should ask to select an action" do
      subject.should_receive(:say).with("It is The Flash's turn. Select a maneuver.")
      subject.turn
    end

    it "should list all the actions for the user" do
      subject.should_receive(:menu).with(%w{Attack Wait})
      subject.turn
    end

    it "should create a new maneuver" do
      attack.should_receive(:new).with(the_flash)
      subject.turn
    end

    it "should tell the maneuver to start" do
      attack_maneuver.should_receive(:start)
      subject.turn
    end

    context "when the maneuver needs to continue" do
      before(:each) do
        attack_maneuver.stub(:continue?).and_return(true, false)
        attack_maneuver.stub(:message) { "hoo is u punchin?" }
        attack_maneuver.stub(:options) { nil }
        attack_maneuver.stub(:next)

        subject.stub(:ask).with('Result:') { '12' }
      end

      it "should show the maneuver's message" do
        subject.should_receive(:say).with('hoo is u punchin?')
        subject.turn
      end

      context "without options" do
        it "should ask for a result" do
          subject.should_receive(:ask).with('Result:')
          subject.turn
        end
      end

      context "with options" do
        before(:each) do
          attack_maneuver.stub(:options) { ['this guy', 'that guy'] }
        end

        it "should list the choices to the user" do
          subject.should_receive(:menu).with(['this guy', 'that guy'])
          subject.turn
        end
      end

      it "should pass the input along to the maneuver" do
        attack_maneuver.should_receive(:next).with('12')
        subject.turn
      end
    end

    context "when the maneuver is done" do
      it "should tell about the end of the turn" do
        subject.should_receive(:say).with("The Flash's turn is over.")
        subject.turn
      end

      it "should display the maneuver's final message" do
        subject.should_receive(:say).with("done nao")
        subject.turn
      end
    end
  end
end
