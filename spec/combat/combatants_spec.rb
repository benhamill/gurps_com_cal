require_relative '../spec_helper'

class CombatantsHolder
  include GurpsComCal::Combat::Combatants
end

describe "GurpsComCal::Combat::Combatants" do
  subject { CombatantsHolder.new }

  describe "#load_combatant" do
    let(:rick) { double(GurpsComCal::Combatant, :name => 'Rick Castle') }

    it "should create a new combatant from a file" do
      GurpsComCal::Combatant.should_receive(:load_yaml).with('path/to/file.yaml') { rick }
      subject.load_combatant('path/to/file.yaml')
    end

    it "should add the combatant that it loads" do
      GurpsComCal::Combatant.stub(:load_yaml) { rick }

      subject.load_combatant('path/to/file.yaml')

      subject.combatant('Rick Castle').should == rick
    end
  end

  context "adding, listing and retreiving combatants" do
    let(:rick) { double(GurpsComCal::Combatant, :name => 'Rick Castle') }
    let(:thug) { double(GurpsComCal::Combatant, :name => 'Thug') }

    before(:each) do
      subject.add_combatant(rick)
      subject.add_combatant(thug)
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
