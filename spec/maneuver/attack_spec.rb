require_relative '../spec_helper'

describe "GurpsComCal::Maneuver::Attack" do
  before(:each) do
    @rick = GurpsComCal::Combatant.new(GurpsComCal::Character.load_yaml(File.join(SPEC_RESOURCES_DIR, 'rick_castle.yaml')))
    @thug = GurpsComCal::Combatant.new(GurpsComCal::Character.load_yaml(File.join(SPEC_RESOURCES_DIR, 'thug.yaml')))

    @defense = double(:fail? => true, :continue? => false, :success? => false, :message => 'message from defense', :options => 'options from defense')
    @defense.stub(:next) { @defense }
    GurpsComCal::Maneuver::Defense.stub(:new) { @defense }
  end

  subject { GurpsComCal::Maneuver::Attack.new @rick }

  it "should start off with asking for a target" do
    subject.next
    subject.message.should == "Rick Castle, select a target."
    subject.options.should == nil
    subject.continue?.should be_true
  end

  context "after selecting a target" do
    context "without an equipped weapon" do
      before(:each) do
        subject.next.next(@thug)
      end

      it "should ask for a weapon to use" do
        subject.message.should == "Rick Castle, select a weapon."
        subject.options.sort.should == ['Fist', 'Large Knife'].sort
        subject.continue?.should be_true
      end
    end

    context "with an equipped weapon" do
      before(:each) do
        @rick.equip_weapon('Fist')
        subject.next.next(@thug)
      end

      it "should go straight to asking for an attack" do
        subject.message.should == 'Rick Castle, select an attack for your Fist.'
        subject.options.should == ['Punch']
        subject.continue?.should be_true
      end
    end
  end

  context "after selecting a weapon" do
    before(:each) do
      subject.next.next(@thug).next('Fist')
    end

    it "should ask which attack to use" do
      subject.message.should == 'Rick Castle, select an attack.'
      subject.options.should == ['Punch']
      subject.continue?.should be_true
    end
  end

  context "after selecting an attack" do
    before(:each) do
      subject.next.next(@thug).next('Fist').next('Punch')
    end

    it "should ask for the result of an attack roll" do
      subject.message.should == 'Rick Castle, roll against 11 and enter the result.'
      subject.options.should == nil
    end
  end

  context "when failing the attack roll" do
    before(:each) do
      subject.next.next(@thug).next('Fist').next('Punch').next(15)
    end

    it "should tell about a miss" do
      subject.message.should == 'A miss! Attack failed.'
      subject.options.should == nil
    end

    it "should end the maneuver with a failure" do
      subject.continue?.should be_false
      subject.fail?.should be_true
      subject.success?.should be_false
    end
  end

  context "when making the attack roll" do
    it "should delegate control to a defence" do
      GurpsComCal::Maneuver::Defense.should_receive(:new).with(@thug) { @defense }
      @defense.should_receive(:next)
      subject.next.next(@thug).next('Fist').next('Punch').next(9)
    end

    it "should append the defense's message to its own" do
      @defense.stub(:continue?) { true }
      subject.next.next(@thug).next('Fist').next('Punch').next(9)
      subject.message.should == 'Success! message from defense'
      subject.options.should == 'options from defense'
    end
  end

  context "while the defense is not yet complete" do
    before(:each) do
      @defense.stub(:continue?) { true }
      @defense.stub(:fail?) { false }
      subject.next.next(@thug).next('Fist').next('Punch').next(9).next
    end

    it "should have the message and options from the defense" do
      subject.message.should == 'message from defense'
      subject.options.should == 'options from defense'
    end

    it "should continue to delegate while the defense is going" do
      subject.next
      subject.message.should == 'message from defense'
      subject.options.should == 'options from defense'
    end
  end

  context "when the defense succeeds" do
    before(:each) do
      @defense.stub(:fail?) { false }
      @defense.stub(:success?) { true }
      @defense.stub(:continue?).and_return(true, false)
      subject.next.next(@thug).next('Fist').next('Punch').next(9).next
    end

    it "should stop delegating" do
      @defense.should_not_receive(:next)
      subject.next
    end

    it "should have the message from the defense" do
      subject.message.should == 'message from defense Attack failed.'
      subject.options.should == nil
    end

    it "should end the action with a failure" do
      subject.continue?.should be_false
      subject.fail?.should be_true
      subject.success?.should be_false
    end
  end

  context "when the defense fails" do
    before(:each) do
      @defense.stub(:continue?).and_return(true, false)
      @defense.stub(:fail?) { true }
      @defense.stub(:success?) { false }
      subject.next.next(@thug).next('Fist').next('Punch').next(9).next
    end

    it "should stop delegating" do
      @defense.should_not_receive(:next)
      subject.next(2)
    end

    it "should have the message from the defense as well as its own" do
      subject.message.should == 'message from defense Rick Castle, roll 1d-3 and enter the result.'
      subject.options.should == nil
      subject.continue?.should be_true
    end
  end

  context "after entering the damage result" do
    before(:each) do
      @defense.stub(:continue?).and_return(true, false)
      @defense.stub(:fail?) { true }
      @defense.stub(:success?) { false }
      subject.next.next(@thug).next('Fist').next('Punch').next(9).next
    end

    it "should apply the damage to the target" do
      @thug.should_receive(:damage).with('cr', 3)
      subject.next(3)
    end

    it "should tell about the amount of damage done" do
      @thug.stub(:damage) { 3 }
      subject.next(3)

      subject.message.should == 'Thug took 3 points of injury. Attack succeeded.'
      subject.options.should == nil
    end

    it "should end the maneuver with success" do
      subject.next(3)
      subject.continue?.should be_false
      subject.fail?.should be_false
      subject.success?.should be_true
    end
  end
end
