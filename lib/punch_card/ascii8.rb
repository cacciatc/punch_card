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
        table[char] || (raise UnsupportedCharacter.create(char, ASCII8))
      end

      def self.table
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

        ('0'..'9').each do |c|
          table[c] = EncodingSymbol.new([c.ord - '0'.ord], c)
        end

        ('a'..'z').each do |c|
          case c
          when 'a'..'i'
            table[c] = EncodingSymbol.new([11, 0, c.ord - 'a'.ord + 1], c)
          when 'j'..'r'
            table[c] = EncodingSymbol.new([11, 10, c.ord - 'j'.ord + 1], c)
          when 's'..'z'
            table[c] = EncodingSymbol.new([10, 0, c.ord + 1 - 's'.ord + 1], c)
          end
        end

        table['-'] = EncodingSymbol.new([10], '-')
        table['&'] = EncodingSymbol.new([11], '&')
      end
    end
  end
end
