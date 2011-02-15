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
  end
end
