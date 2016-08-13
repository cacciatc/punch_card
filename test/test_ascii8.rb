require './test/test_helper'

include PunchCard::Formats
describe 'ASCII8' do
  it 'should fail gracefully if there is too much data to encode' do
    string = Array.new(81) { |_i| 'A' }.join

    assert_raises InsufficientCardSpace do
      PunchCard::Encodings::ASCII8.encode(string, IBM5081)
    end
  end

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

  it 'should decode the alphabet in upper case' do
    expected = ('A'..'Z').to_a.join('')
    card = PunchCard::Encodings::ASCII8.encode(expected, IBM5081)

    letters = PunchCard::Encodings::ASCII8.decode(card)
    assert letters.rstrip == expected,
           'The card did not decode successfully. ' \
      			"The card decoded to #{letters}; should have been #{expected}."
  end

  it 'should encode the digits 0-9' do
    expected = ('0'..'9').to_a.join('')
    card = PunchCard::Encodings::ASCII8.encode(expected, IBM5081)

    ('0'..'9').each_with_index do |l, i|
      expected = '1'.rjust(i + 1, '0') + '0'.ljust(11 - i, '0')
      card_str = card[i].join

      assert card_str == expected,
             "The card did not encode the digit '#{l}'. " \
             "Column was #{card_str}; should have been #{expected}."
    end
  end
end
