require_relative 'ascii8'

module PunchCard
  # Contains all the supported encodings.
  module Encodings
    # You just want ALL the characters don't you?!
    class UnsupportedCharacter < StandardError
      def self.create(char, encoding)
        msg = "#{encoding} does not support the character '#{char}'."
        UnsupportedCharacter.new(msg)
      end
    end

    # Sorry we just can't decode it.
    class UndecodableCharacter < StandardError
      def self.create(pattern, encoding)
        msg = "#{encoding} does not know of the pattern '#{pattern}'."
        UndecodableCharacter.new(msg)
      end
    end

    # Not all column patterns are good.
    class BadColumnPattern < StandardError
      def self.create(pattern, _encoding)
        msg = "#{pattern} is not valid encoding."
        BadColumnPattern.new(msg)
      end
    end

    # Represents a symbol in a column
    class EncodingSymbol
      attr_reader :symbol
      # TODO: assumes 12 rows per col, should be flexible
      def initialize(pattern, symbol)
        raise BadColumnPattern.create unless pattern.length <= 12
        @pattern = pattern
        @symbol  = symbol
        @col     = Array.new(12) { CLEAR }

        @pattern.each do |row|
          @col[row] = PUNCH
        end
      end

      def decodable?(col)
        col == @col
      end

      def punch(card, col)
        @pattern.each do |row|
          card[col][row] = PUNCH
        end

        card
      end
    end
  end
end
