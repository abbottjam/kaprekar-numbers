# (number) -> boolean
def kaprekar?(number)
  return false if number <= 0
  return true if number.eql? 1
  splits = two_part_splits(number)
  sums = sums(splits)
  sums.include? number
end

# (number) -> array of arrays
def two_part_splits(number)
  generate_splits(number_to_array(number))
end

# (number) -> array of digits
def number_to_array(number)
  square = number**2
  digits = square.to_s.split ""
end

# (array of digits) -> array of arrays of digits
def generate_splits(digits, arrays=[], i=0)
  n = digits.size
  return arrays if i.eql? n
  head = digits.slice(0, i).join("")
  tail = digits.slice(i, n).join("")
  return arrays if tail.to_i.eql? 0 # (1)
  arrays << [head, tail]
  generate_splits(digits, arrays, i+1)
end

# (array of arrays) - > array of numbers
def sums(digits)
  digits.map do |arr|
    arr
    .map { |digit| digit.to_i }
    .reduce { |sum, number| sum + number }
  end
end

require 'minitest/spec'
require 'minitest/autorun'
require_relative 'data'

describe "finding kaprekar numbers" do
  before do
    @digits = [
     ["", "2025"],
     ["2", "025"],
     ["20", "25"],
     ["202", "5"]
    ]

    @small_range = {
      -3 => false,
      -2 => false,
      -1 => false,
       0 => false,
       1 => true,
       2 => false,
       3 => false,
       4 => false,
       5 => false,
       6 => false,
       7 => false,
       8 => false,
       9 => true,
      10 => false
    }
  end

  it "identifies 45 as Kaprekar number" do
    kaprekar?(45).must_equal true
  end

  it "converts a number into an array of digits" do
    number_to_array(45).must_equal ["2", "0", "2", "5"]
  end

  it "creates all possible 2-part splits of the sequence '2045'" do
    two_part_splits(45).must_equal @digits
  end

  # (1) If the 2nd part of the split consists of zeros, the sum of the parts
  #     is not a Kaprekar number: http://en.wikipedia.org/wiki/Kaprekar_number
  it "decides that 10 is not a Kaprekar number, although '1' + '00' = '10' + '0' = '100'" do
    kaprekar?(10).must_equal false
  end

  it "correctly splits edge cases (trailing zeros and 1-digit numbers)" do
    two_part_splits(2).must_equal [["", "4"]]
    two_part_splits(10).must_equal [["", "100"]] # (1)
  end

  it "finds Kaprekar numbers in the range -3..10" do
    @small_range.keys.map { |num| kaprekar? num }.must_equal @small_range.values
  end

  it "finds Kaprekar numbers in large sample" do
    results = KAPREKAR.map { |num| kaprekar? num }
    results.include?(false).must_equal false
  end

  it "finds no Kaprekar numbers in large sample" do
    results = NOT_KAPREKAR.map { |num| kaprekar? num }
    results.include?(true).must_equal false
  end
end
