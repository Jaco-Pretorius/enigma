# frozen_string_literal: true

class RotorConfiguration
  class << self
    def from_yaml(hash)
      new(name: hash['name'], wiring: hash['wiring'], notches: hash['notches'])
    end
  end

  attr_reader :name, :wiring, :notches

  def initialize(name:, wiring:, notches:)
    @name = name
    @wiring = wiring.chars.map { |letter| AlphabetHelper.letter_to_index(letter) }
    @notches = notches.chars.map { |letter| AlphabetHelper.letter_to_index(letter) }
  end
end
