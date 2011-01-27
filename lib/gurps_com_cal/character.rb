require_relative 'character/attributes'
require_relative 'character/yaml'

module GurpsComCal
  class Character
    include Attributes
    include Yaml

    def initialize options = {}
      options.each_key do |key|
        self.send("#{key}=", options[key]) if self.respond_to? "#{key}="
      end
    end

    attr_writer :name

    def name
      @name || 'Goon'
    end

    def dice_math *args
      dice_hash = args.inject({:dice => 0, :adds => 0}) do |hash, dice_string|
        if dice_string =~ /d/
          dice, adds = dice_string.split('d')
          hash[:dice] += dice.to_i
          hash[:adds] += adds.to_i
        else
          hash[:adds] += dice_string.to_i
        end

        hash
      end

      if dice_hash[:adds] < 0
        adds = dice_hash[:adds].to_s
      elsif dice_hash[:adds] > 0
        adds = "+#{dice_hash[:adds]}"
      else
        adds = ''
      end

      "#{dice_hash[:dice]}d#{adds}"
    end
  end
end
