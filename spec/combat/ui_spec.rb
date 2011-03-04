require_relative '../spec_helper'

class UIHolder
  include GurpsComCal::Combat::UI
end

describe "GurpsComCal::Combat::UI" do
  subject { UIHolder.new }

  describe "#say" do
    it "should print the message" do
      subject.should_receive(:puts).with('Would you like to play a game?')
      subject.say('Would you like to play a game?')
    end
  end

  describe "#menu" do
    before(:each) do
      subject.stub(:ask) { "2" }
      subject.stub(:say)
    end

    it "should print all the array elements with a number" do
      subject.should_receive(:say).with("1. First option")
      subject.should_receive(:say).with("2. Second option")
      subject.should_receive(:say).with("3. Third option")
      subject.menu(['First option', 'Second option', 'Third option'])
    end

    it "should ask for a selection" do
      subject.should_receive(:ask).with('Selection:')
      subject.menu(['First option', 'Second option', 'Third option'])
    end

    it "should return the selected option" do
      subject.menu(['First option', 'Second option', 'Third option']).should == 'Second option'
    end
  end

  describe "#ask" do
    it "should use gets to gather input" do
      subject.should_receive(:gets).with('foo')
      subject.ask('foo')
    end

    it "should pass along gathered input" do
      subject.stub(:gets) { '12' }
      subject.ask('foo').should == '12'
    end

    context "when the 'exit' command is entered" do
      before(:each) do
        subject.stub(:gets) { 'exit' }
      end

      it "quit the program" do
        lambda { subject.ask('What is your favorite color?') }.should raise_error SystemExit
      end
    end

    context "when the 'load combatant' command is entered" do
      before(:each) do
        subject.stub(:gets).with('What is your favorite color?').and_return('load combatant', '12')
        subject.stub(:gets).with('Enter file name:') { 'path/to/file.yaml' }
        subject.stub(:load_combatant)
      end

      it "should ask for the file path" do
        subject.should_receive(:gets).with('Enter file name:')
        subject.ask('What is your favorite color?')
      end

      it "should load the combatant" do
        subject.should_receive(:load_combatant).with('path/to/file.yaml')
        subject.ask('What is your favorite color?')
      end

      it "should ask for the other input when it's done" do
        subject.should_receive(:gets).with('What is your favorite color?').exactly(2).times
        subject.ask('What is your favorite color?')
      end
    end
  end
end
