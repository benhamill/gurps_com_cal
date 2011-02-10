require_relative '../spec_helper'

describe "GurpsComCal::Weapon::MeleeAttack" do
  context "class methods" do
    subject { GurpsComCal::Weapon::MeleeAttack }

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
end
