require_relative '../spec_helper'

describe "GurpsComCal::Weapon::MeleeAttack" do
  context "class methods" do
    subject { GurpsComCal::Weapon::MeleeAttack }

    describe "new" do
      before(:each) do
        @s = subject.new(:weapon, 'STAB!', 'a lot', :none, 'long', 1000, -9)
      end

      # This is a sanity check on a super() call. See the weapon/attack_spec for more coverage.
      it "should save the attack's name" do
        @s.instance_variable_get('@name').should == 'STAB!'
      end

      it "should accept reach as an array" do
        s = subject.new(:weapon, 'STAB!', 'a lot', :none, ['C', '1'], 1000, -9)
        s.instance_variable_get('@reach').should == %w{C 1}
      end

      it "should accept a single reach, but store it as an array" do
        s = subject.new(:weapon, 'STAB!', 'a lot', :none, 'C', 1000, -9)
        s.instance_variable_get('@reach').should == %w{C}
      end

      it "should store the parry modifier" do
        @s.instance_variable_get('@parry_modifier').should == 1000
      end

      it "should store the attack type as 'melee'" do
        @s.instance_variable_get('@type').should == 'melee'
      end
    end

    describe "from_hash" do
      it "should pull relevant fields from the hash" do
        hash = {
          'weapon' => :weapon,
          'name' => 'STAB!',
          'damage' => 'a lot',
          'skills' => :none,
          'reach' => 'long',
          'parry_modifier' => +1000,
          'min_st' => '-9'
        }

        subject.should_receive(:new).with(:weapon, 'STAB!', 'a lot', :none, 'long', 1000, -9)
        subject.from_hash(hash)
      end

      it "should ignore irrelevant fields in the hash" do
        hash = {
          'weapon' => :weapon,
          'name' => 'STAB!',
          'damage' => 'a lot',
          'skills' => :none,
          'reach' => 'long',
          'parry_modifier' => +1000,
          'min_st' => '-9',
          'reloads' => :infinity,
          'int' => 18
        }

        subject.should_receive(:new).with(:weapon, 'STAB!', 'a lot', :none, 'long', 1000, -9)
        subject.from_hash(hash)
      end
    end
  end

  context "instance methods" do
    subject { GurpsComCal::Weapon::MeleeAttack.new @weapon, 'STAB!', '1d-2', %w{Fightin'}, ['C'], -2, 10 }

    before(:each) do
      @weapon = double
    end

    describe "parry" do
      it "should apply the parry modifier to the appropriate skill" do
        subject.should_receive(:skill) { 13 }
        subject.parry.should == 11
      end
    end
  end
end
