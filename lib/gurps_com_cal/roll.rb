module GurpsComCal
  class Roll
    attr_accessor :dice, :adds

    def self.result roll=Roll.new('3d')
      r = Array.new(roll.dice).inject(0) do |memo, nothing|
        memo + rand(6) + 1
      end

      r + roll.adds
    end

    def initialize dice, adds = 0
      if dice.respond_to? :split
        d, a = dice.split('d')
        dice = d.to_i
        adds += a.to_i
      end

      @dice = dice.to_i
      @adds = adds.to_i
    end

    def == other
      if other.respond_to?(:dice) and other.respond_to?(:adds)
        self.dice == other.dice && self.adds == other.adds
      else
        false
      end
    end

    def + other
      if other.respond_to?(:dice) and other.respond_to?(:adds)
        Roll.new(self.dice + other.dice, self.adds + other.adds)
      else
        Roll.new(self.dice, self.adds + other.to_i)
      end
    end

    def - other
      if other.respond_to?(:dice) and other.respond_to?(:adds)
        Roll.new(self.dice - other.dice, self.adds - other.adds)
      else
        Roll.new(self.dice, self.adds - other.to_i)
      end
    end

    def to_s
      sign = adds < 0 ? '' : '+'
      ending = adds == 0 ? '' : "#{sign}#{adds.to_s}"
      "#{dice.to_s}d#{ending}"
    end

    def result
      Roll.roll self
    end
  end
end
