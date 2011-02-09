module GurpsComCal
  class Character
    class Skill
      attr_reader :name

      def initialize character, name, attribute, modifier=0
        @character = character
        @name = name

        attribute.upcase!

        if attribute.to_s =~ /([A-Z]+)((\+|-)\d+)/
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

      def self.from_hash hash
        new(hash['character'], hash['name'], hash['level'])
      end

      def level
        @character.send(@attribute.downcase) + @modifier
      end
    end
  end
end
