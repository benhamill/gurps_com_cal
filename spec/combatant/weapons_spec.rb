require_relative '../spec_helper'

class WeaponsHolder
  include GurpsComCal::Combatant::Weapons
end

describe "GurpsComCal::Combatant::Weapons" do
  before(:each) do
    @character = double(GurpsComCal::Character)
    subject.instance_variable_set('@character', @character)
  end

  subject { WeaponsHolder.new }

  describe "#equip_weapon" do
    before(:each) do
      @weapon = double(GurpsComCal::Weapon, :name => 'Fist')
      @character.stub(:weapon).with('Fist') { @weapon }
    end

    context "with a weapon the character owns" do
      it "should accept a weapon as an argument" do
        arg_weapon = double(GurpsComCal::Weapon, :name => 'Fist')
        @weapon.stub(:==).with(arg_weapon) { true }

        subject.equip_weapon(arg_weapon)
        subject.equipped_weapon.should == @weapon
      end

      it "should accept a string as an argument" do
        subject.equip_weapon('Fist')
        subject.equipped_weapon.should == @weapon
      end
    end
  end
end
