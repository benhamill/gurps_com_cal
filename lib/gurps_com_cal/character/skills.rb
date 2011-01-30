module GurpsComCal
  class Character
    class Skill
      def initialize character, name, attribute, modifier=0
        @character = character
        @name = name

        if attribute.to_s =~ /([a-z]+)((\+|-)\d+)/
          attribute = $1
          modifier = $2
        end

        @attribute = attribute.to_s
        @modifier = modifier.to_i
      end

      def inspect
        instance_vars = instance_variables.collect do |var|
          next if var == :@character
          "#{var.to_s}=#{instance_variable_get(var).inspect}"
        end.compact.join(' ')

        "#<#{self.class} #{instance_vars}>"
      end

      def to_hash
        sign = @modifier < 0 ? '' : '+'
        ending = @modifier == 0 ? '' : "#{sign}#{@modifier.to_s}"
        level = "#{@attribute}#{ending}"
        {'name' => @name, 'level' => level}
      end

      def from_hash hash
        new(hash['character'], hash['name'], hash['level'])
      end

      def level
        @character.send(@attribute) + @modifier
      end
    end

    module Skills
      attr_reader :skills

      def skills= skills_array
        @skills = {}

        skills_array.each do |skill_hash|
          @skills[skill_hash['name']] = Skill.from_hash({ 'character' => self }.merge(skill_hash))
        end
      end

      def skill skill_name
        @skills[skill_name]
      end
    end
  end
end
