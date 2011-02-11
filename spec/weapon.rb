require_relative 'spec_helper'

describe "GurpsComCal::Weapon" do
  context "class methods" do
    subject { GurpsComCal::Weapon }

    describe "new" do
      it "should take a character, name and weight" do
        subject.new(double, 'Rick Castle', 180).should be_a(GurpsComCal::Weapon)
      end

      it "should take a character and name with no weight" do
        subject.new(double, 'Rick Castle').should be_a(GurpsComCal::Weapon)
      end
    end

    describe "from_hash" do
      it "should create a new weapon from the hash" do
        char = double
        hash = {
          'character' => char,
          'name' => 'Rick Castle',
          'weight' => 180
        }

        subject.should_receive(:new).with(char, 'Rick Castle', 180)
        subject.from_hash(hash)
      end

      it "should try to create melee attacks from hash data" do
        char = double
        hash = {
          'character' => char,
          'name' => 'Rick Castle',
          'weight' => 180,
          'attacks' => [{ 'name' => 'STAB!', 'type' => 'melee' }]
        }
        weapon = double
        subject.stub(:new).with(char, 'Rick Castle', 180) { weapon }

        attack = double(:name => 'STAB!')
        GurpsComCal::Weapon::MeleeAttack.should_receive(:from_hash).with(hash_including('weapon' => anything, 'name' => 'STAB!')) { attack }
        weapon.should_receive(:attacks=).with([attack])
        subject.from_hash(hash)
      end
    end
  end
end
