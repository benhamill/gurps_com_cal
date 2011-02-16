require_relative '../spec_helper'

describe "GurpsComCal::Maneuver::Base" do
  subject { GurpsComCal::Maneuver::Base.new @character }

  before(:each) do
    @character = double
  end

  describe "initialization" do
    it "should take an actor" do
      subject.actor.should == @character
    end
  end

  describe "#next" do
    it "should invoke the #start when first called" do
      subject.should_receive(:start)
      subject.next
    end

    it "should call the next-set method" do
      subject.instance_variable_set('@next_method', :foo)
      subject.should_receive(:foo)
      subject.next
    end

    it "should take in an argument and pass them along to the called method" do
      subject.instance_variable_set('@next_method', :foo)
      subject.should_receive(:foo).with('bar')
      subject.next('bar')
    end

    it "should pass more than one argument received to the called method" do
      subject.instance_variable_set('@next_method', :foo)
      subject.should_receive(:foo).with('bar', 'baz', 'bom')
      subject.next('bar', 'baz', 'bom')
    end

    it "should return the same object" do
      subject.stub(:start)
      subject.next().should == subject
    end
  end

  describe "#message" do
    before(:each) do
      subject.instance_variable_set('@message', "Hello.")
    end

    it "should return a message" do
      subject.message.should == 'Hello.'
    end

    it "should not retain the message between steps" do
      subject.stub(:foo)
      subject.instance_variable_set('@next_method', :foo)
      subject.next
      subject.message.should == nil
    end
  end

  describe "#options" do
    before(:each) do
      subject.instance_variable_set('@options', %w{yes no maybe})
    end

    it "should return options" do
      subject.options.should == %w{yes no maybe}
    end

    it "should not retain the options between steps" do
      subject.stub(:foo)
      subject.instance_variable_set('@next_method', :foo)
      subject.next
      subject.options.should == nil
    end
  end
end
