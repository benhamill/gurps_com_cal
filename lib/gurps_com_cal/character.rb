require_relative 'character/attributes'
require_relative 'character/yaml'
require_relative 'character/weapons'
require_relative 'character/skills'
require_relative 'character/base'

module GurpsComCal
  class Character
    include Base
    include Attributes
    include Yaml
    include Weapons
    include Skills
  end
end
