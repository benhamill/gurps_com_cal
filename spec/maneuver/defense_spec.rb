require_relative '../spec_helper'

describe "GurpsComCal::Maneuver::Defense" do
  before(:each) do
    @rick = GurpsComCal::Combatant.new(GurpsComCal::Character.load_yaml(File.join(SPEC_RESOURCES_DIR, 'rick_castle.yaml')))
    @rick.equip_weapon('Fist')
  end

  subject { GurpsComCal::Maneuver::Defense.new @rick }

  it "should start off asking to select a defense" do
    subject.next
    subject.message.should == 'Rick Castle, select a defense.'
    subject.options.sort.should == %w{dodge parry}.sort
    subject.continue?.should be_true
  end

  context "after selecting dodge" do
    before(:each) do
      subject.next.next('dodge')
    end

    it "should ask for the result of a dodge roll" do
      subject.message.should == 'Rick Castle, roll against 8 and enter the result.'
      subject.options.should == nil
      subject.continue?.should be_true
    end

    context "and succeeding" do
      before(:each) do
        subject.next(5)
      end

      it "should tell about success" do
        subject.message.should == 'A success!'
        subject.options.should == nil
      end

      it "should not indicate continuation" do
        subject.continue?.should be_false
      end

      it "should indicate success" do
        subject.fail?.should be_false
        subject.success?.should be_true
      end
    end

    context "and failing" do
      before(:each) do
        subject.next(10)
      end

      it "should tell about a failure" do
        subject.message.should == 'A failure!'
        subject.options.should == nil
      end

      it "should not indicate continuation" do
        subject.continue?.should be_false
      end

      it "should indicate failure" do
        subject.success?.should be_false
        subject.fail?.should be_true
      end
    end
  end
end
