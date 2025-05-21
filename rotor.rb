# frozen_string_literal: true

class Rotor
  attr_reader :position

  def initialize(configuration:, starting_position:, ring_setting:)
    @configuration = configuration
    @position = AlphabetHelper.letter_to_index(starting_position)
    @ring_setting = AlphabetHelper.letter_to_index(ring_setting)
  end

  def forward_encode_letter(letter)
    input_index = (letter + @position - @ring_setting) % 26
    (@configuration.wiring[input_index] - @position + @ring_setting) % 26
  end

  def backward_encode_letter(letter)
    input_index = (letter + @position - @ring_setting) % 26
    (@configuration.wiring.index(input_index) - @position + @ring_setting) % 26
  end

  def rotate
    @position = (@position + 1) % 26
  end

  def notches
    @configuration.notches
  end

  def rotation_points
    notches.map { |notch| (notch + 1) % 26 }
  end
end
