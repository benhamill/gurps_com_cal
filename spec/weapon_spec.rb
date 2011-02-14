require_relative 'spec_helper'

describe "GurpsComCal::Weapon" do
  context "class methods" do
    subject { GurpsComCal::Weapon }

    describe "new" do
      it "should take a character, name and weight" do
        subject.new(double, 'Glamdring', 12).should be_a(GurpsComCal::Weapon)
      end

      it "should take a character and name with no weight" do
        subject.new(double, 'Glamdring').should be_a(GurpsComCal::Weapon)
      end
    end

    describe "from_hash" do
      it "should create a new weapon from the hash" do
        char = double
        hash = {
          'character' => char,
          'name' => 'Glamdring',
          'weight' => 12
        }

        subject.should_receive(:new).with(char, 'Glamdring', 12)
        subject.from_hash(hash)
      end

      it "should try to create melee attacks from hash data" do
        char = double
        hash = {
          'character' => char,
          'name' => 'Glamdring',
          'weight' => 12,
          'attacks' => [{ 'name' => 'STAB!', 'type' => 'melee' }]
        }
        weapon = double
        subject.stub(:new).with(char, 'Glamdring', 12) { weapon }

        attack = double(:name => 'STAB!')
        GurpsComCal::Weapon::MeleeAttack.should_receive(:from_hash).with(hash_including('weapon' => anything, 'name' => 'STAB!')) { attack }
        weapon.should_receive(:attacks=).with([attack])
        subject.from_hash(hash)
      end
    end
  end

  context "instance methods" do
    subject { GurpsComCal::Weapon.new(@character, 'Glamdring', 12) }

    describe "inspect" do
      it "should make with a string" do
        subject.inspect.should be_a(String)
      end
    end

    describe "attacks" do
      context "just one attack" do
        before(:each) do
          @slash = double(GurpsComCal::Weapon::MeleeAttack, :name => 'Slash', :to_ary => nil)
          subject.attacks = @slash
        end

        it "should return a list of the attacks" do
          subject.attacks.should == ["Slash"]
        end

        it "should retreive an attack by name" do
          subject.attack("Slash").should == @slash
        end
      end

      context "several attacks" do
        before(:each) do
          @slash = double(:name => 'Slash', :to_ary => nil)
          @stab = double(:name => 'Stab', :to_ary => nil)
          subject.attacks = [@slash, @stab]
        end

        it "should return a list of the attacks" do
          subject.attacks.should == ["Slash", 'Stab']
        end

        it "should retreive an attack by name" do
          subject.attack("Slash").should == @slash
        end
      end
    end

    describe "to_hash" do
      before(:each) do
        @attacks = [
          double(:name => 'Slash', :to_ary => nil, :to_hash => { 'name' => 'Slash' }),
          double(:name => 'Stab', :to_ary => nil, :to_hash => { 'name' => 'Stab' }),
        ]

        subject.attacks = @attacks
      end

      it "should return a hash of instance variables" do
        subject.to_hash['name'].should == 'Glamdring'
        subject.to_hash['weight'].should == 12
      end

      it "should make a special case for attacks" do
        @attacks.each do |attack|
          attack.should_receive(:to_hash)
        end

        subject.to_hash['attacks'].should == [
          { 'name' => 'Slash' },
          { 'name' => 'Stab' }
        ]
      end

      it "should not include the character" do
        subject.to_hash['character'].should == nil
      end
    end
  end
end
