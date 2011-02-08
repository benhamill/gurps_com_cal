require 'gurps_com_cal/character/yaml'

class CharacterYamlHolder
  include GurpsComCal::Character::Yaml
end

describe "GurpsComCal::Character::Yaml" do
  context "class methods" do
    subject { CharacterYamlHolder }

    before(:each) do
      yaml = <<-YAML
        ---
        name: Eris
        epithets:
          - Discordia
          - Strife
      YAML

      @directory = "tmp/specs"
      @file_location = "#{@directory}/test.yaml"

      Dir.mkdir(@directory) unless Dir.exists?(@directory)
      File.open(@file_location, 'w') do |file|
        file.puts yaml
      end
    end

    after(:each) do
      File.delete(@file_location)
    end

    it "should parse a yaml file and hand it to new" do
      subject.should_receive(:new).with({'name' => 'Eris', 'epithets' => ['Discordia', 'Strife']})
      subject.from_yaml(@file_location)
    end
  end

  context "instance methods" do
    subject { CharacterYamlHolder.new }

    describe "to_hash" do
      it "should convert the method to a hash of the instance variables" do
        subject.instance_variable_set '@foo', 'foo'
        subject.instance_variable_set '@bar', 'bar'
        subject.instance_variable_set '@baz', 'baz'

        subject.to_hash.should == { 'foo' => 'foo', 'bar' => 'bar', 'baz' => 'baz' }
      end

      it "should handle a special case for the instance variable 'weapons'" do
        weapons = {:a => double, :b => double, :c => double}

        subject.instance_variable_set '@foo', 'foo'
        subject.instance_variable_set '@weapons', weapons

        weapons.each_with_index do |weapon, i|
          weapon[1].should_receive(:to_hash) { { 'number' => i } }
        end

        subject.to_hash.should == {
          'foo' => 'foo',
          'weapons' => [
            { 'number' => 0 },
            { 'number' => 1 },
            { 'number' => 2 }
          ]
        }
      end

      it "should handle a special case for the instance variable 'skills'" do
        skills = {:a => double, :b => double, :c => double}

        subject.instance_variable_set '@foo', 'foo'
        subject.instance_variable_set '@skills', skills

        skills.each_with_index do |skill, i|
          skill[1].should_receive(:to_hash) { { 'number' => i } }
        end

        subject.to_hash.should == {
          'foo' => 'foo',
          'skills' => [
            { 'number' => 0 },
            { 'number' => 1 },
            { 'number' => 2 }
          ]
        }
      end
    end
  end
end
