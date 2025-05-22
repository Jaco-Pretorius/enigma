# frozen_string_literal: true

class Plugboard
  # plugs = ["ab", "gd", ...]
  def initialize(plugs)
    @plugs = {}

    plugs.each do |pair|
      l1 = AlphabetHelper.letter_to_index(pair[0])
      l2 = AlphabetHelper.letter_to_index(pair[1])

      @plugs[l1] = l2
      @plugs[l2] = l1
    end
  end

  def encode_letter(letter_index)
    @plugs.fetch(letter_index, letter_index)
  end
end
