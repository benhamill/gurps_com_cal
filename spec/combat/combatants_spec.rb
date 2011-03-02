require_relative '../spec_helper'

class CombatantsHolder
  include GurpsComCal::Combat::Combatants
end

describe "GurpsComCal::Combat::Combatants" do
  subject { CombatantsHolder.new }

  describe "#load_combatant" do
    it "should create a new combatant from a file" do
      GurpsComCal::Combatant.should_receive(:load_yaml).with('path/to/file.yaml')
      subject.load_combatant('path/to/file.yaml')
    end
  end

  context "adding, listing and retreiving combatants" do
    let(:rick) { double(GurpsComCal::Combatant, :name => 'Rick Castle') }
    let(:thug) { double(GurpsComCal::Combatant, :name => 'Thug') }

    before(:each) do
      subject.add_combatant(rick)
      subject.add_combatant(thug)
    end

    describe "add_combatant" do
      it "should take a Combatant object" do
        subject.instance_variable_get(:@combatants).should == { 'Rick Castle' => rick, 'Thug' => thug }
      end
    end

    describe "combatants" do
      it "should list all the combatants" do
        subject.combatants.sort.should == ['Rick Castle', 'Thug'].sort
      end
    end

    describe "combatant" do
      it "should retrieve a combatant by name" do
        subject.combatant('Rick Castle').should == rick
      end
    end
  end
end
