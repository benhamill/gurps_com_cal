require 'yaml'

module GurpsComCal
  class Character
    module Yaml
      module ClassMethods
        def from_yaml file=nil
          file ||= "tmp/goon.yaml"

          new YAML.load(File.read(file))
        end
      end

      module InstanceMethods
        def to_yaml file=nil
          file ||= "tmp/#{name.downcase}.yaml"

          File.open(file, 'w') do |f|
            f.puts YAML.dump(to_hash)
          end
        end

        def to_hash
          instance_variables.inject({}) do |hash, variable|
            stat_name = variable.to_s.downcase.gsub('@', '')

            value = instance_variable_get(variable)

            if stat_name == 'weapons'
              value = value.collect do |weapon_name, weapon|
                weapon.to_hash
              end
            elsif stat_name == 'skills'
              value = value.collect do |skill_name, skill|
                skill.to_hash
              end
            end

            hash[stat_name] = value
            hash
          end
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end
