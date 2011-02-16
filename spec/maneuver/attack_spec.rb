require_relative '../spec_helper'

describe "GurpsComCal::Maneuver::Attack" do
  before(:all) do
    file = File.join(SPEC_WORKING_DIR, 'rick_castle.yaml')
    File.delete(file) if File.exists?(file)

    File.open(file, 'w') do |f|
      f.puts <<-YAML
        ---
        name: Rick Castle
        iq: 12
        dx: 11
        ht: 11
        skills:
          - name: Brawling
            level: DX
          - name: Knife
            level: DX+1
        weapons:
          - name: Fist
            weight: 0
            attacks:
              - name: Punch
                type: melee
                damage: thr-1 cr
                skills:
                  - Boxing
                  - Brawling
                  - Karate
                  - DX
                reach:
                  - C
                min_st: 0
                parry_modifier: 0
          - name: Large Knife
            weight: 1
            attacks:
              - name: Swing
                type: melee
                damage: sw-2 cut
                skills:
                  - Knife
                reach:
                  - C
                  - 1
                min_st: 6
                parry_modifier: -1
              - name: Thrust
                type: melee
                damage: thr imp
                skills:
                  - Knife
                reach:
                  - C
                min_st: 6
                parry_modifier: -1
      YAML
    end

    @attacker = GurpsComCal::Character.load_yaml file
    @thug = GurpsComCal::Character.load_yaml file
    @thug.st = 12
    @thug.iq = 9
    @thug.dx = 10
  end

  subject { GurpsComCal::Maneuver::Attack.new @attacker }

  it "should start off with asking for a target" do
    subject.next
    subject.message.should == "Rick Castle, select a target."
    subject.options.should == nil
  end
end
