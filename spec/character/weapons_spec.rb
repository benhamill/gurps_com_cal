require_relative '../spec_helper'

class WeaponsHolder
  include GurpsComCal::Character::Weapons
end

describe "GurpsComCal::Character::Weapons" do
  subject { WeaponsHolder.new }

  before(:each) do
    GurpsComCal::Weapon.stub(:from_hash) do |arg|
      arg['name']
    end

    weapon_list = [
      { 'name' => 'Fist' },
      { 'name' => 'Mouth' },
      { 'name' => 'Gun' }
    ]
    subject.weapons = weapon_list
  end

  it "should assign weapons as an array of objects" do
    subject.instance_variable_get('@weapons').should == { 'Fist' => 'Fist', 'Mouth' => 'Mouth', 'Gun' => 'Gun' }
  end

  it "should return a list of weapon names" do
    subject.weapons.sort.should == %w{Fist Mouth Gun}.sort
  end

  it "should retrieve a weapon by name" do
    subject.weapon('Mouth').should == 'Mouth'
  end
end
