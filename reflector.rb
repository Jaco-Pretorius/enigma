# frozen_string_literal: true

class Reflector
  def initialize(wiring:)
    @mapping = wiring.chars.map.with_index { |letter, index| [index, AlphabetHelper.letter_to_index(letter)] }.to_h
  end

  def encode(letter)
    @mapping.fetch(letter)
  end
end
