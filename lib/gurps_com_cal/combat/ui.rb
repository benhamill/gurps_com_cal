module GurpsComCal
  class Combat
    module UI
      def say message
        puts message
      end

      def menu options
        options.each_with_index do |option, index|
          say "#{index + 1}. #{option}"
        end
        input = ask "Selection:"

        options[input.to_i - 1]
      end

      def ask message
        loop do
          input = gets(message)

          case input
          when 'exit'
            exit
          when 'load combatant'
            file = ask 'Enter file name:'
            self.load_combatant(file)
          else
            return input
          end
        end
      end
    end
  end
end
