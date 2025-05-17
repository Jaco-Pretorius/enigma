# frozen_string_literal: true

class Rotor
  attr_reader :position

  def initialize(configuration:, position:)
    @configuration = configuration
    @position = position
  end

  def forward_encode_letter(letter)
    input_index = (letter + @position) % 26
    (@configuration.wiring[input_index] - @position) % 26
  end

  def backward_encode_letter(letter)
    input_index = (letter + @position) % 26
    (@configuration.wiring.index(input_index) - @position) % 26
  end

  def rotate
    yield if block_given? && @configuration.notch == @position
    @position = (@position + 1) % 26
  end
end
