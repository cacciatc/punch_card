require 'date'

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

    # You just want to put ALL the things on the card don't you?!
    class InsufficientCardSpace < StandardError
      def self.create(format, string)
        msg = "This #{format} does not contain enough space to /
					encode \"#{string}\"."
        InsufficientCardSpace.new(msg)
      end
    end

    # Classic 80x12
    class IBM5081
      extend Forwardable

      ROWS = 12
      COLS = 80

      attr_accessor :comments
      def initialize
        @a = Array.new(COLS) { Array.new(ROWS) { CLEAR } }
        @comments = ''
      end

      def_delegator :@a, :[], :[]
      def_delegator :@a, :length, :length
      def_delegator :@a, :each, :each
      def_delegator :@a, :inject, :inject

      def to_txt(fname = nil)
        rows = to_rows

        date = DateTime.now.strftime('%d %B %Y - %H:%M:%S')
        str  = "IBM 5081 created #{date}\n"
        str += "#{comments.chars.join(' ')}\n"
        str += format_row(rows[11], 11) + "\n"
        str += format_row(rows[10], 10) + "\n"

        rows[0..ROWS - 2].each_with_index do |row, i|
          str += format_row(row, i) + "\n"
        end

        if fname.nil?
          str
        else
          File.open(fname, 'w') do |f|
            f.puts str
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
