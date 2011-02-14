require_relative '../spec_helper'

describe "GurpsComCal::Weapon::Attack" do
  describe "initialization" do
    context "no given minimum strength" do
      subject do
        GurpsComCal::Weapon::Attack.new(@weapon, 'Burn', '2d burn', ["Pyromania", "Fireworks"])
      end

      before(:each) do
        @weapon = double
        @damage = double

        GurpsComCal::Weapon::Damage.should_receive(:new).with(anything, '2d burn').and_return(@damage)
      end

      it "should report a weapon, name, damage and skill list" do
        subject.name.should == 'Burn'
        subject.skills.should == ["Pyromania", "Fireworks"]
        subject.damage.should == @damage
      end

      it "should report the default minimum strength of 0" do
        subject.min_st.should == 0
      end
    end

    context "a given minimum strength" do
      subject do
        GurpsComCal::Weapon::Attack.new(@weapon, 'Burn', '2d burn', ["Pyromania", "Fireworks"], 11)
      end

      before(:each) do
        @weapon = double
        @damage = double

        GurpsComCal::Weapon::Damage.should_receive(:new).with(anything, '2d burn').and_return(@damage)
      end

      it "should report a weapon, name, damage and skill list" do
        subject.name.should == 'Burn'
        subject.skills.should == ["Pyromania", "Fireworks"]
        subject.damage.should == @damage
      end

      it "should report the given minimum strength" do
        subject.min_st.should == 11
      end
    end
  end

  context "an instantiated object" do
    subject do
      GurpsComCal::Weapon::Attack.new(@weapon, 'Burn', '2d burn', ["Pyromania", "Fireworks"])
    end

    before(:each) do
      @weapon = double
      @damage = double

      GurpsComCal::Weapon::Damage.should_receive(:new).with(anything, '2d burn').and_return(@damage)
    end

    describe "#inspect" do
      it "should return a string" do
        subject.inspect.should be_a(String)
      end
    end

    describe "#to_hash" do
      it "should have instance variables in the hash" do
        subject.to_hash['name'].should == 'Burn'
        subject.to_hash['skills'].should == ['Pyromania', 'Fireworks']
        subject.to_hash['min_st'].should == 0
      end

      it "should not include the weapon" do
        subject.to_hash['weapon'].should == nil
      end

      it "should handle a special case for damage" do
        @damage.should_receive(:to_s) { '2d burn' }
        subject.to_hash['damage'].should == '2d burn'
      end
    end

    describe "#character" do
      it "should proxy the character method on weapon" do
        @weapon.should_receive(:character) { :character }
        subject.character.should == :character
      end
    end

    describe "#skill" do
      context "with a character with only one applicable skill" do
        before(:each) do
          @character = double
          @character.stub(:skill).with('Pyromania') { double(:level => 10) }
          @character.stub(:skill).with('Fireworks') { nil }
          @weapon.stub(:character) { @character }
        end

        it "should return the skill's level" do
          subject.skill.should == 10
        end
      end

      context "with a character with more than one applicable skill" do
        before(:each) do
          @character = double
          @character.stub(:skill).with('Pyromania') { double(:level => 10) }
          @character.stub(:skill).with('Fireworks') { double(:level => 12) }
          @weapon.stub(:character) { @character }
        end

        it "should return the highest skill's level" do
          subject.skill.should == 12
        end
      end
    end
  end
end
