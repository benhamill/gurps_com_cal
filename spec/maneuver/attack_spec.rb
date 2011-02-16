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
    @thug.st = 12
    @thug.iq = 9
    @thug.dx = 10
  end

  subject { GurpsComCal::Maneuver::Attack.new @attacker }

  it "should start off with asking for a target" do
    subject.next
    subject.message.should == "Rick Castle, select a target."
    subject.options.should == nil
  end

  context "after selecting a target" do
    before(:each) do
      subject.next.next(@thug)
    end

    it "should ask for a weapon to use" do
      subject.message.should == "Rick Castle, select a weapon."
      subject.options.sort.should == ['Fist', 'Large Knife'].sort
    end
  end

  context "after selecting a weapon" do
    before(:each) do
      subject.next.next(@thug).next('Fist')
    end

    it "should ask which attack to use" do
      subject.message.should == 'Rick Castle, select an attack.'
      subject.options.should == ['Punch']
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

  context "after failing the attack roll" do
    before(:each) do
      subject.next.next(@thug).next('Fist').next('Punch').next(15)
    end

    it "should end the maneuver" do
      pending "How do we signal the end of a maneuver?"
    end
  end

  context "after making the attack roll" do
    before(:each) do
      subject.next.next(@thug).next('Fist').next('Punch').next(9)
    end

    context "when the defender can defend" do
      it "should ask the defender to select a defense" do
        subject.message.should == 'Thug, select a defense.'
        subject.options.sort.should == ['Parry', 'Dodge'].sort
      end
    end

    context "when the defender can't defend" do
      pending "Needs more design thought."
    end
  end

  context "after the defender chooses a defense" do
    pending "Oh man, do I need to think about defense machinery."
  end
end
