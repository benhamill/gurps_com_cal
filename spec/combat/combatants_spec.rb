require_relative '../spec_helper'

class CombatantsHolder
  include GurpsComCal::Combat::Combatants
end

describe "GurpsComCal::Combat::Combatants" do
  subject { CombatantsHolder.new }

  describe "#load_combatant" do
    let(:rick) { GurpsComCal::Combatant.new(GurpsComCal::Character.new(:name => 'Rick Castle')) }

    before(:each) do
      GurpsComCal::Combatant.stub(:load_yaml) { rick }
    end

    it "should create a new combatant from a file" do
      GurpsComCal::Combatant.should_receive(:load_yaml).with('path/to/file.yaml') { rick }
      subject.load_combatant('path/to/file.yaml')
    end

    it "should add the combatant that it loads" do
      subject.load_combatant('path/to/file.yaml')
      subject.combatant('Rick Castle').should == rick
    end

    context "with :as option" do
      it "should rename the combatant before adding it" do
        rick.should_receive(:name=).with('Jameson Rook')
        subject.load_combatant('path/to/file.yaml', :as => 'Jameson Rook')
      end

      it "should use the new name for retrieval" do
        subject.load_combatant('path/to/file.yaml', :as => 'Jameson Rook')
        subject.combatant('Jameson Rook').should == rick
      end

      it "should NOT use the old name for retrieval" do
        subject.load_combatant('path/to/file.yaml', :as => 'Jameson Rook')
        subject.combatant('Rick Castle').should == nil
      end
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

  describe "#mook" do
    it "should load a file n times" do
      subject.should_receive(:load_combatant).exactly(3).times
      subject.mook('path/to/file.yaml', 3)
    end

    it "should append a number to the given name" do
      subject.should_receive(:load_combatant).with('path/to/file.yaml', :as => 'thug_1').ordered
      subject.should_receive(:load_combatant).with('path/to/file.yaml', :as => 'thug_2').ordered
      subject.should_receive(:load_combatant).with('path/to/file.yaml', :as => 'thug_3').ordered
      subject.mook('path/to/file.yaml', 3, 'thug')
    end

    it "should default the name to 'mook'" do
      subject.should_receive(:load_combatant).with('path/to/file.yaml', :as => 'mook_1').ordered
      subject.should_receive(:load_combatant).with('path/to/file.yaml', :as => 'mook_2').ordered
      subject.should_receive(:load_combatant).with('path/to/file.yaml', :as => 'mook_3').ordered
      subject.mook('path/to/file.yaml', 3)
    end
  end
end
