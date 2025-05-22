# frozen_string_literal: true

class Reflector
  class << self
    def from_yaml(hash)
      new(name: hash['name'], wiring: hash['wiring'])
    end
  end

  attr_reader :name

  def initialize(name:, wiring:)
    @name = name
    @mapping = wiring.chars.map.with_index { |letter, index| [index, AlphabetHelper.letter_to_index(letter)] }.to_h
  end

  def encode(letter)
    @mapping.fetch(letter)
  end
end
