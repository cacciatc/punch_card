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

      def to_txt(fname)
        File.open(fname, 'w') do |f|
          rows = to_rows
          f.puts(format_row(rows[11], 11))
          f.puts(format_row(rows[10], 10))

          rows[0..ROWS - 2].each_with_index do |row, i|
            f.puts(format_row(row, i))
          end
        end
      end

      def format_cell(cell, row)
        if cell == PUNCH
          'X'
        else
          [11, 10].include?(row) ? ' ' : row
        end
      end

      def format_row(row, index)
        row.collect { |cell| format_cell(cell, index) }.join(' ')
      end

      def to_rows
        rows = Array.new(ROWS) { [] }
        @a.each do |row|
          ROWS.times do |i|
            rows[i] << row[i]
          end
        end

        rows
      end
    end
  end
end
