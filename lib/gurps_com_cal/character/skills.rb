require_relative 'skill'

module GurpsComCal
  class Character
    module Skills
      def skills= skills_array
        @skills = {}

        skills_array.each do |skill_hash|
          @skills[skill_hash['name']] = Skill.from_hash({ 'character' => self }.merge(skill_hash))
        end
      end

      def skills
        @skills.keys
      end

      def skill skill_name
        @skills[skill_name]
      end
    end
  end
end
