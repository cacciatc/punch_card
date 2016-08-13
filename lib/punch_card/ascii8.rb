module PunchCard
  module Encodings
    # Good k

    # Good ole 8-bit ASCII
    module ASCII8
      @@table = {}

      def self.encode(str, format)
        if format == Formats::IBM5081
          encode_IBM5081(str, format.new)
        else
          raise UnsupportedCardFormat.create(format)
        end
      end

      def self.decode(card)
        if card.class == Formats::IBM5081
          decode_IBM5081(card)
        else
          raise UnsupportedCardFormat.create(Formats::IBM5081)
        end
      end

      def self.encode_IBM5081(str, card)
        col = 0
        str.each_char do |c|
          if col >= card.length
            raise Formats::InsufficientCardSpace.create(Formats::IBM5081, str)
          end

          punch_column(card, col, c)
          col += 1
        end

        card
      end

      def self.decode_IBM5081(card)
        card.inject('') do |result, col|
          result + decode_column(col)
        end
      end

      # TODO: this is brute force search, could be optimized
      def self.decode_column(col)
        table = get_or_build_table
        result = table.detect do |_k, encoding_sym|
          encoding_sym.decodable?(col)
        end

        if result.nil? || result.empty?
          raise UndecodableCharacter.create(col.join, ASCII8)
        end

        result.first
      end

      def self.punch_column(card, col, char)
        lookup_symbol(char).punch(card, col)
      end

      def self.lookup_symbol(char)
        table = get_or_build_table

        table[char] || (raise UnsupportedCharacter.create(char, ASCII8))
      end

      def self.get_or_build_table
        create_symbols(@@table) if @@table.empty?
        @@table
      end

      def self.create_symbols(table)
        # blank
        table[' '] = EncodingSymbol.new([], ' ')

        ('A'..'Z').each do |c|
          case c
          when 'A'..'I'
            table[c] = EncodingSymbol.new([11, c.ord - 'A'.ord + 1], c)
          when 'J'..'R'
            table[c] = EncodingSymbol.new([10, c.ord - 'J'.ord + 1], c)
          when 'S'..'Z'
            table[c] = EncodingSymbol.new([0, c.ord + 1 - 'S'.ord + 1], c)
          end
        end
      end
    end
  end
end
