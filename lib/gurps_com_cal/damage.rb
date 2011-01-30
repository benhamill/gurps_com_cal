module GurpsComCal
  class Damage
    attr_reader :type

    def initialize attack, damage_roll, type=nil
      unless type
        damage_roll, type = damage_roll.split
      end

      @attack = attack
      @type = type

      if damage_roll.kind_of? Roll
        @roll = damage_roll
      elsif damage_roll[0] =~ /\d/
        @roll = Roll.new(damage_roll)
      else
        damage_roll.downcase.match(/(thr|sw)(.*)/)
        @damage_base = $1
        @damage_mod = $2.to_i
      end
    end

    def inspect
      instance_vars = instance_variables.collect do |var|
        next if var == :@attack
        "#{var.to_s}=#{instance_variable_get(var).inspect}"
      end.compact.join(' ')

      "#<#{self.class} #{instance_vars}>"
    end

    def roll
      return @roll if @roll
      return @attack.character.send(@damage_base) + @damage_mod
    end

    def to_s
      unless @roll
        sign = @damage_mod < 0 ? '' : '+'
        ending = @damage_mod == 0 ? '' : "#{sign}#{@damage_mod.to_s}"
        r = "#{@damage_base}#{ending}"
      else
        r = @roll.to_s
      end

      "#{r} #{@type}"
    end
  end
end
