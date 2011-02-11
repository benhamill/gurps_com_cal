require_relative '../spec_helper'

class BaseHolder
  include GurpsComCal::Character::Base
end

describe "GurpsComCal::Character::Base" do
  context "with no args at creation" do
    subject { BaseHolder.new }

    it "should work" do
      subject.should be_a(GurpsComCal::Character::Base)
    end

    it "should give the default name, 'Goon'" do
      subject.name.should == 'Goon'
    end

    it "should inspect with some kind of string" do
      subject.inspect.should be_a(String)
    end
  end

  context "with args at creation" do
    subject { BaseHolder.new(:name => 'Rick Castle', :profession => 'Author') }

    it "should store relevant options" do
      subject.name.should == 'Rick Castle'
    end
  end
end
