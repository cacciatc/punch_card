module PunchCard
  PUNCH = 1
  CLEAR = 0

  module Formats
    # You just want ALL the card formats don't you?!
    class UnsupportedCardFormat < StandardError
      def self.create(format)
        msg = "#{format} is currently not supported."
        UnsupportedCardFormat.new(msg)
      end
    end

    # Classic 80x12
    class IBM5081
      extend Forwardable

      ROWS = 12
      COLS = 80

      def initialize
        @a = Array.new(COLS) { Array.new(ROWS) { CLEAR } }
      end

      def_delegator :@a, :[], :[]
      def_delegator :@a, :length, :length
      def_delegator :@a, :each, :each
    end
  end
end
