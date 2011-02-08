require 'gurps_com_cal/character/yaml'

class CharacterYamlHolder
  include GurpsComCal::Character::Yaml
end

describe "GurpsComCal::Character::Yaml" do
  subject { CharacterYamlHolder.new }

  context "loading a yaml file" do
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
      CharacterYamlHolder.should_receive(:new).with({'name' => 'Eris', 'epithets' => ['Discordia', 'Strife']})
      CharacterYamlHolder.from_yaml(@file_location)
    end
  end
end
