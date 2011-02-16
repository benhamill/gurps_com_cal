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
  end

  describe "#message" do
    it "should return a message" do
      subject.instance_variable_set('@message', "Hello.")
      subject.message.should == 'Hello.'
    end
  end

  describe "#options" do
    it "should return options" do
      subject.instance_variable_set('@options', %w{yes no maybe})
      subject.options.should == %w{yes no maybe}
    end
  end
end
