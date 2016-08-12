require './test/test_helper'

include PunchCard::Formats
describe 'ASCII8' do
  it 'should encode the alphabet in upper case' do
    letters = ('A'..'Z').to_a.join('')
    card    = PunchCard::Encodings::ASCII8.encode(letters, IBM5081)

    ('A'..'I').each_with_index do |l, i|
      expected = '01'.rjust(i + 2, '0') + '1'.rjust(10 - i, '0')
      card_str = card[i].join

      assert card_str == expected,
             "The card did not encode the letter '#{l}'. " \
             "Column was #{card_str}; should have been #{expected}."
    end

    offset = 9
    ('J'..'R').each_with_index do |l, i|
      expected = '01'.rjust(i + 2, '0') + '10'.rjust(10 - i, '0')
      card_str = card[i + offset].join

      assert card_str == expected,
             "The card did not encode the letter '#{l}'. " \
             "Column was #{card_str}; should have been #{expected}."
    end

    offset = 18
    ('S'..'Z').each_with_index do |l, i|
      expected = '1' + '1'.rjust(i + 2, '0') + '0'.rjust(9 - i, '0')
      card_str = card[i + offset].join

      assert card_str == expected,
             "The card did not encode the letter '#{l}'. " \
            "Column was #{card_str}; should have been #{expected}."
    end
  end
end
