require 'gurps_com_cal/character/attributes'
require 'gurps_com_cal/character/yaml'

module GurpsComCal
  class Character
    include Attributes
    include Yaml

    attr_writer :name

    def initialize options = {}
      options.each_key do |key|
        self.send("#{key}=", options[key]) if self.respond_to? "#{key}="
      end
    end

    def name
      @name || 'Goon'
    end
  end
end
