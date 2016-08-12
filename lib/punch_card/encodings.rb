module PunchCard
  module Encodings
    # You just want ALL the characters don't you?!
    class UnsupportedCharacter < StandardError
      def self.create(char, encoding)
        msg = "#{encoding} does not support the character '#{char}'."
        UnsupportedCharacter.new(msg)
      end
    end

    # Good ole 8-bit ASCII
    module ASCII8
      def self.encode(str, format)
        if format == IBM5081
          encode_IBM5081(str, format.new)
        else
          raise UnsupportedCardFormat.create(format)
        end
      end

      def self.encode_IBM5081(str, card)
        col = 0
        str.each_char do |c|
          case c
          when 'A'..'I'
            card[col][11] = PUNCH
            card[col][c.ord - 'A'.ord + 1] = PUNCH
          when 'J'..'R'
            card[col][10] = PUNCH
            card[col][c.ord - 'J'.ord + 1] = PUNCH
          when '/'
            card[col][0] = PUNCH
            card[col][0] = PUNCH
          when 'S'..'Z'
            card[col][0] = PUNCH
            card[col][c.ord + 1 - 'S'.ord + 1] = PUNCH
          else
            raise UnsupportedCharacter.create(c, ASCII8)
          end
          col += 1
        end

        card
      end
    end
  end
end
