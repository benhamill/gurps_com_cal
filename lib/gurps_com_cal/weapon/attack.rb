require_relative 'damage'

module GurpsComCal
  class Weapon
    class Attack
      attr_reader :name, :damage, :skills, :min_st

      def initialize weapon, name, damage, skills, min_st=0
        @weapon = weapon
        @name = name
        @damage = Damage.new self, damage
        @skills = [skills].flatten
        @min_st = min_st
      end

      def inspect
        instance_vars = instance_variables.collect do |var|
          next if var == :@weapon
          "#{var.to_s}=#{instance_variable_get(var).inspect}"
        end.compact.join(' ')

        "#<#{self.class} #{instance_vars}>"
      end

      def to_hash
        instance_variables.inject({}) do |hash, variable|
          unless variable == :@weapon
            stat_name = variable.to_s.gsub(/@/, '')
            value = instance_variable_get(variable)
            value = value.to_s if stat_name == 'damage'

            hash[stat_name] = value
          end

          hash
        end
      end

      def character
        @weapon.character
      end

      def skill
        skills.collect do |skill|
          character.skill(skill).try :level
        end.max
      end
    end
  end
end
