require_relative '../spec_helper.rb'
require 'gurps_com_cal/character/skills'

class SkillsHolder
  include GurpsComCal::Character::Skills
end

describe "GurpsComCal::Character::Skills" do
  subject { SkillsHolder.new }

  before(:each) do
    GurpsComCal::Character::Skill.stub(:from_hash) do |arg|
      arg['name']
    end

    skill_list = [
      { 'name' => "Fightin'" },
      { 'name' => "Spittin'" },
      { 'name' => "Shootin'" },
    ]
    subject.skills = skill_list
  end

  it "should assign skills as an array of objects" do
    subject.instance_variable_get('@skills').should == {"Fightin'"=>"Fightin'", "Spittin'"=>"Spittin'", "Shootin'"=>"Shootin'"}
  end

  it "should return a list of skill names" do
    subject.skills.should == %w{Fightin' Spittin' Shootin'}
  end

  it "should retrieve a skill by name" do
    subject.skill("Fightin'").should == "Fightin'"
  end
end
