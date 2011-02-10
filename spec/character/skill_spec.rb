require_relative '../spec_helper'

describe GurpsComCal::Character::Skill do
  context "class methods" do
    subject { GurpsComCal::Character::Skill }

    describe "initialize" do
      it "should take an attribute with no modifier" do
        s = subject.new(double, "Fightin'", 'DX')
        s.instance_variable_get('@attribute').should == 'DX'
        s.instance_variable_get('@modifier').should == 0
      end

      it "should take an attribute and a modifier" do
        s = subject.new(double, "Fightin'", 'DX', 3)
        s.instance_variable_get('@attribute').should == 'DX'
        s.instance_variable_get('@modifier').should == 3
      end

      it "should parse the attribute and modifier from a string" do
        s = subject.new(double, "Fightin'", 'DX-2')
        s.instance_variable_get('@attribute').should == 'DX'
        s.instance_variable_get('@modifier').should == -2
      end
    end

    describe "from_hash" do
      it "should pull out character, name and level from the hash" do
        char = double
        hash = {
          'character' => char,
          'name' => "Fightin'",
          'level' => 'DX-1'
        }

        subject.should_receive(:new).with(char, "Fightin'", 'DX-1')
        subject.from_hash(hash)
      end

      it "should ignore extraneous values in the hash" do
        char = double
        hash = {
          'character' => char,
          'name' => "Fightin'",
          'level' => 'DX-1',
          'awesomeness' => 10_000_000_000,
          'color' => [:black, :blue, :red_all_over]
        }

        subject.should_receive(:new).with(char, "Fightin'", 'DX-1')
        subject.from_hash(hash)
      end
    end
  end

  context "instance methods" do
    subject { GurpsComCal::Character::Skill.new(@character, "Fightin'", 'DX', -2) }

    before(:each) do
      @character = double
    end

    describe "inspect" do
      it "should return a string, because, really, I don't care" do
        subject.inspect.should be_a(String)
      end
    end

    describe "to_hash" do
      it "should return the name in a hash" do
        subject.to_hash['name'].should == "Fightin'"
      end

      it "should calculate the level into a string from the attribute and modifier" do
        subject.to_hash['level'].should == "DX-2"
      end
    end

    describe "level" do
      it "should ask the character for the relevant attribute and apply the modifier" do
        @character.should_receive(:dx).and_return(10)
        subject.level.should == 8
      end
    end
  end
end
