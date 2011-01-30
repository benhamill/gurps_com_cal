module GurpsComCal
  class Character
    module Weapons
      attr_reader :weapons

      def weapons= weapons_array
        @weapons = {}
        weapons_array.each do |weapon_hash|
          @weapons[weapon_hash['name']] = Weapon.from_hash({ 'character' => self }.merge(weapon_hash))
        end
      end

      def weapon weapon_name
        @weapons[weapon_name]
      end
    end
  end
end
