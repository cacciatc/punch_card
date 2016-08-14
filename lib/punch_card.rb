require 'punch_card/version'
require 'punch_card/formats'
require 'punch_card/encodings'

# Holds all the punch card fun!
module PunchCard
  def self.create(string, format, encoding)
    card = encoding.encode(string, format)
    card.comments = string
    card
  end
end
