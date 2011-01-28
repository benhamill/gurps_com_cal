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
  end
end
