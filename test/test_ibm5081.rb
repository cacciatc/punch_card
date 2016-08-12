require './test/test_helper'

describe 'IBM5081' do
  it 'should have 80 columns and 12 rows' do
    card = PunchCard::Formats::IBM5081.new
    expected_rows = 12
    expected_cols = 80

    assert card.length == expected_cols
    card.each do |col|
      assert col.length == expected_rows
    end
  end
end
