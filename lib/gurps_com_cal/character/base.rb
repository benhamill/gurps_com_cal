module GurpsComCal
  class Character
    def initialize options = {}
      options.each_key do |key|
        self.send("#{key}=", options[key]) if self.respond_to? "#{key}="
      end
    end

    def inspect
      instance_vars = instance_variables.collect do |var|
        "#{var.to_s}=#{instance_variable_get(var).inspect}"
      end.join(' ')

      "#<#{self.class} #{instance_vars}>"
    end

    attr_writer :name

    def name
      @name || 'Goon'
    end
  end
end
