# frozen_string_literal: true

class Rotor
  attr_reader :position

  def initialize(configuration:, position:)
    @configuration = configuration
    @position = position
  end

  def forward_encode_letter(letter)
    input_index = (letter.ord - 'A'.ord + @position) % 26
    mapped_letter = @configuration.wiring[input_index]
    output_index = (mapped_letter.ord - 'A'.ord - @position) % 26
    (output_index + 'A'.ord).chr
  end

  def backward_encode_letter(letter)
    input_index = (letter.ord - 'A'.ord + @position) % 26
    index_in_wiring = @configuration.wiring.index((input_index + 'A'.ord).chr)
    output_index = (index_in_wiring - @position) % 26
    (output_index + 'A'.ord).chr
  end

  def rotate
    notch_triggered = (@configuration.notch.ord - 'A'.ord) == @position
    @position = (@position + 1) % 26
    yield if block_given? && notch_triggered
  end
end
