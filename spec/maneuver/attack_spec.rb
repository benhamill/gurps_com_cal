require_relative '../spec_helper'

describe "GurpsComCal::Maneuver::Attack" do
  before(:all) do
    file = File.join(SPEC_WORKING_DIR, 'rick_castle.yaml')
    File.delete(file) if File.exists?(file)

    File.open(file, 'w') do |f|
      f.puts <<-YAML
        ---
        name: Rick Castle
        iq: 12
        dx: 11
        ht: 11
        skills:
          - name: Brawling
            level: DX
          - name: Knife
            level: DX+1
        weapons:
          - name: Fist
            weight: 0
            attacks:
              - name: Punch
                type: melee
                damage: thr-1 cr
                skills:
                  - Boxing
                  - Brawling
                  - Karate
                  - DX
                reach:
                  - C
                min_st: 0
                parry_modifier: 0
          - name: Large Knife
            weight: 1
            attacks:
              - name: Swing
                type: melee
                damage: sw-2 cut
                skills:
                  - Knife
                reach:
                  - C
                  - 1
                min_st: 6
                parry_modifier: -1
              - name: Thrust
                type: melee
                damage: thr imp
                skills:
                  - Knife
                reach:
                  - C
                min_st: 6
                parry_modifier: -1
      YAML
    end

    @attacker = GurpsComCal::Character.load_yaml file
    @thug = GurpsComCal::Character.load_yaml file
    @thug.name = 'Thug'
    @thug.st = 12
    @thug.iq = 9
    @thug.dx = 10

    @defense = double(:fail? => true, :continue? => false, :success? => false, :message => 'message from defense', :options => 'options from defense')
    @defense.stub(:next) { @defense }
    GurpsComCal::Maneuver::Defense.stub(:new) { @defense }
  end

  subject { GurpsComCal::Maneuver::Attack.new @attacker }

  it "should start off with asking for a target" do
    subject.next
    subject.message.should == "Rick Castle, select a target."
    subject.options.should == nil
    subject.continue?.should be_true
  end

  context "after selecting a target" do
    before(:each) do
      subject.next.next(@thug)
    end

    it "should ask for a weapon to use" do
      subject.message.should == "Rick Castle, select a weapon."
      subject.options.sort.should == ['Fist', 'Large Knife'].sort
      subject.continue?.should be_true
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
      subject.message.should == 'A miss! Maneuver ended.'
      subject.options.should == nil
    end

    it "should end the maneuver with a failure" do
      subject.continue?.should be_false
      subject.fail?.should be_true
      subject.success?.should be_false
    end
  end

  context "when making the attack roll" do
    after(:each) do
      subject.next.next(@thug).next('Fist').next('Punch').next(9)
    end

    it "should delegate control to a defence" do
      GurpsComCal::Maneuver::Defense.should_receive(:new) { @defense }
      @defense.should_receive(:next)
      subject.message.should == 'message from defense'
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
      subject.next.next(@thug).next('Fist').next('Punch').next(9)
    end

    it "should stop delegating" do
      @defense.should_not_receive(:next)
      subject.next
    end

    it "should tell have the message and options form the defense" do
      subject.message.should == 'message from defense'
      subject.options.should == 'options from defense'
    end

    it "should end the action with a failure" do
      subject.continue?.should be_false
      subject.fail?.should be_true
      subject.success?.should be_false
    end
  end

  context "when the defense fails" do
    pending
  end
end
