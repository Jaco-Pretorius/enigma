# frozen_string_literal: true

class Reflector
  def initialize(wiring:)
    alphabet = ('A'..'Z').to_a
    @mapping = wiring.chars.map.with_index { |letter, index| [alphabet[index], letter] }.to_h
  end

  def encode(letter)
    @mapping.fetch(letter)
  end
end
