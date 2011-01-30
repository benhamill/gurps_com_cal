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
            stat_name = variable.to_s.downcase.gsub(/ +/, '_').gsub(/[^a-z_]/, '')

            value = instance_variable_get(variable)
            value = value.to_hash if stat_name == 'weapons'

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
