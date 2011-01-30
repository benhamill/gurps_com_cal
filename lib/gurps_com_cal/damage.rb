module GurpsComCal
  class Damage
    attr_reader :type

    def initialize attack, damage_roll, type=nil
      unless type
        damage_roll, type = damage_roll.split
      end

      @attack = attack
      @type = type

      if damage_roll.type_of? Roll
        @roll = damage_roll
      elsif damage_roll[0] =~ /\d/
        @roll = Roll.new(damage_roll)
      else
        damage_roll.downcase.match(/(thr|sw)(.*)/)
        @damage_base = $1
        @damage_mod = $2.to_i
      end
    end

    def roll
      return @roll if @roll
      return Roll.new(@attack.character.send(@damage_base), @damage_mod)
    end

    def to_s
      "#{roll.to_s} #{@type}"
    end
  end
end
